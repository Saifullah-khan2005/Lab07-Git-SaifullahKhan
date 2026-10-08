`timescale 1ns / 1ps

module top_rf_alu (

    input        clk,
    input        rst,

    input  [15:0] switches,
    output [15:0] leds,

    // Seven segment display
    output [6:0] seg,
    output [3:0] an

);

    // =========================================================
    // RESET
    // =========================================================

    wire reset_debounced;

    Debounce #(
        .COUNT_MAX(2_000_000)
    ) RESET_DEBOUNCE (

        .clk(clk),
        .btn_in(rst),
        .btn_out(reset_debounced)

    );


    // =========================================================
    // SLOW CLOCK ENABLE
    // 100 MHz clock
    // FSM changes state every 0.5 seconds
    // =========================================================

    reg [25:0] clock_counter;
    reg slow_enable;

    always @(posedge clk) begin

        if (reset_debounced) begin

            clock_counter <= 26'd0;
            slow_enable <= 1'b0;

        end

        else begin

            if (clock_counter == 26'd49_999_999) begin

                clock_counter <= 26'd0;
                slow_enable <= 1'b1;

            end

            else begin

                clock_counter <= clock_counter + 1'b1;
                slow_enable <= 1'b0;

            end

        end

    end


    // =========================================================
    // REGISTER FILE SIGNALS
    // =========================================================

    reg WriteEnable;

    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;

    reg [31:0] WriteData;

    wire [31:0] ReadData1;
    wire [31:0] ReadData2;


    // =========================================================
    // REGISTER FILE
    // =========================================================

    RegisterFile RF (

        .clk(clk),
        .rst(reset_debounced),

        .WriteEnable(WriteEnable),

        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),

        .WriteData(WriteData),

        .ReadData1(ReadData1),
        .ReadData2(ReadData2)

    );


    // =========================================================
    // ALU SIGNALS
    // =========================================================

    reg A_invert;
    reg B_invert;
    reg CarryIn;

    reg [2:0] Operation;

    wire [31:0] ALUResult;

    wire ALUSet;
    wire ALUOverflow;
    wire ALUZero;


    // =========================================================
    // ALU
    // =========================================================

    ALU #(
        .WIDTH(32)
    ) ALU_UNIT (

        .A(ReadData1),
        .B(ReadData2),

        .A_invert(A_invert),
        .B_invert(B_invert),
        .CarryIn(CarryIn),

        .Operation(Operation),

        .Result(ALUResult),

        .set(ALUSet),
        .overflow(ALUOverflow),
        .Zero(ALUZero)

    );


    // =========================================================
    // FSM STATE REGISTER
    // =========================================================

    reg [4:0] state;


    // =========================================================
    // FSM STATES
    // =========================================================

    localparam IDLE             = 5'd0;

    localparam WRITE_X1         = 5'd1;
    localparam WRITE_X2         = 5'd2;
    localparam WRITE_X3         = 5'd3;

    localparam ADD_WRITE_X4     = 5'd4;
    localparam SUB_WRITE_X5     = 5'd5;
    localparam AND_WRITE_X6     = 5'd6;
    localparam OR_WRITE_X7      = 5'd7;
    localparam XOR_WRITE_X8     = 5'd8;

    localparam SLL_WRITE_X9     = 5'd9;
    localparam SRL_WRITE_X10    = 5'd10;

    localparam BEQ_CHECK        = 5'd11;
    localparam FLAG_WRITE       = 5'd12;

    localparam READ_WRITE_TEST  = 5'd13;
    localparam READ_AFTER_WRITE = 5'd14;

    localparam DONE              = 5'd15;


    // =========================================================
    // BEQ FLAG REGISTER
    // =========================================================

    reg beq_flag;


    // =========================================================
    // FSM STATE TRANSITION
    // =========================================================

    always @(posedge clk) begin

        if (reset_debounced) begin

            state <= IDLE;

        end

        else if (slow_enable) begin

            case (state)

                IDLE:
                    state <= WRITE_X1;

                WRITE_X1:
                    state <= WRITE_X2;

                WRITE_X2:
                    state <= WRITE_X3;

                WRITE_X3:
                    state <= ADD_WRITE_X4;

                ADD_WRITE_X4:
                    state <= SUB_WRITE_X5;

                SUB_WRITE_X5:
                    state <= AND_WRITE_X6;

                AND_WRITE_X6:
                    state <= OR_WRITE_X7;

                OR_WRITE_X7:
                    state <= XOR_WRITE_X8;

                XOR_WRITE_X8:
                    state <= SLL_WRITE_X9;

                SLL_WRITE_X9:
                    state <= SRL_WRITE_X10;

                SRL_WRITE_X10:
                    state <= BEQ_CHECK;

                BEQ_CHECK:
                    state <= FLAG_WRITE;

                FLAG_WRITE:
                    state <= READ_WRITE_TEST;

                READ_WRITE_TEST:
                    state <= READ_AFTER_WRITE;

                READ_AFTER_WRITE:
                    state <= DONE;

                DONE:
                    state <= DONE;

                default:
                    state <= IDLE;

            endcase

        end

    end


    // =========================================================
    // SAVE BEQ RESULT
    // =========================================================

    always @(posedge clk) begin

        if (reset_debounced) begin

            beq_flag <= 1'b0;

        end

        else if (slow_enable) begin

            if (state == BEQ_CHECK) begin

                if (ALUZero)
                    beq_flag <= 1'b1;

                else
                    beq_flag <= 1'b0;

            end

        end

    end


    // =========================================================
    // CONTROL SIGNALS
    // =========================================================

    always @(*) begin

        // Default values

        WriteEnable = 1'b0;

        rs1 = 5'd0;
        rs2 = 5'd0;
        rd  = 5'd0;

        WriteData = 32'd0;

        A_invert = 1'b0;
        B_invert = 1'b0;
        CarryIn  = 1'b0;

        Operation = 3'b000;


        case (state)


            // =================================================
            // WRITE x1
            // =================================================

            WRITE_X1: begin

                WriteEnable = 1'b1;

                rd = 5'd1;

                WriteData = 32'h1010_1010;

            end


            // =================================================
            // WRITE x2
            // =================================================

            WRITE_X2: begin

                WriteEnable = 1'b1;

                rd = 5'd2;

                WriteData = 32'h0101_0101;

            end


            // =================================================
            // WRITE x3
            // =================================================

            WRITE_X3: begin

                WriteEnable = 1'b1;

                rd = 5'd3;

                WriteData = 32'd5;

            end


            // =================================================
            // ADD
            // x4 = x1 + x2
            // =================================================

            ADD_WRITE_X4: begin

                rs1 = 5'd1;
                rs2 = 5'd2;

                Operation = 3'b011;

                WriteEnable = 1'b1;

                rd = 5'd4;

                WriteData = ALUResult;

            end


            // =================================================
            // SUB
            // x5 = x1 - x2
            // =================================================

            SUB_WRITE_X5: begin

                rs1 = 5'd1;
                rs2 = 5'd2;

                Operation = 3'b011;

                B_invert = 1'b1;
                CarryIn = 1'b1;

                WriteEnable = 1'b1;

                rd = 5'd5;

                WriteData = ALUResult;

            end


            // =================================================
            // AND
            // x6 = x1 AND x2
            // =================================================

            AND_WRITE_X6: begin

                rs1 = 5'd1;
                rs2 = 5'd2;

                Operation = 3'b000;

                WriteEnable = 1'b1;

                rd = 5'd6;

                WriteData = ALUResult;

            end


            // =================================================
            // OR
            // x7 = x1 OR x2
            // =================================================

            OR_WRITE_X7: begin

                rs1 = 5'd1;
                rs2 = 5'd2;

                Operation = 3'b001;

                WriteEnable = 1'b1;

                rd = 5'd7;

                WriteData = ALUResult;

            end


            // =================================================
            // XOR
            // x8 = x1 XOR x2
            // =================================================

            XOR_WRITE_X8: begin

                rs1 = 5'd1;
                rs2 = 5'd2;

                Operation = 3'b010;

                WriteEnable = 1'b1;

                rd = 5'd8;

                WriteData = ALUResult;

            end


            // =================================================
            // SLL
            // x9 = x1 << x3
            // =================================================

            SLL_WRITE_X9: begin

                rs1 = 5'd1;
                rs2 = 5'd3;

                Operation = 3'b100;

                WriteEnable = 1'b1;

                rd = 5'd9;

                WriteData = ALUResult;

            end


            // =================================================
            // SRL
            // x10 = x1 >> x3
            // =================================================

            SRL_WRITE_X10: begin

                rs1 = 5'd1;
                rs2 = 5'd3;

                Operation = 3'b101;

                WriteEnable = 1'b1;

                rd = 5'd10;

                WriteData = ALUResult;

            end


            // =================================================
            // BEQ CHECK
            // x1 == x1
            // =================================================

            BEQ_CHECK: begin

                rs1 = 5'd1;
                rs2 = 5'd1;

                Operation = 3'b011;

                B_invert = 1'b1;
                CarryIn = 1'b1;

            end


            // =================================================
            // WRITE BEQ FLAG
            // x11 = 1
            // =================================================

            FLAG_WRITE: begin

                WriteEnable = 1'b1;

                rd = 5'd11;

                if (beq_flag)
                    WriteData = 32'd1;

                else
                    WriteData = 32'd0;

            end


            // =================================================
            // READ-AFTER-WRITE TEST
            // x12 = ABCDEF01
            // =================================================

            READ_WRITE_TEST: begin

                WriteEnable = 1'b1;

                rd = 5'd12;

                WriteData = 32'hABCD_EF01;

            end


            // =================================================
            // READ x12
            // =================================================

            READ_AFTER_WRITE: begin

                rs1 = 5'd12;

            end


            // =================================================
            // DONE
            // =================================================

            DONE: begin

                // Nothing

            end


            default: begin

                // Default values already assigned

            end

        endcase

    end


    // =========================================================
    // LED DISPLAY
    // =========================================================

    reg [15:0] led_data;

    always @(*) begin

        led_data = ALUResult[15:0];


        // Initial FSM states
        if (state <= WRITE_X3) begin

            led_data = {11'd0, state};

        end


        // ALU operations
        else if (
            (state == ADD_WRITE_X4)  ||
            (state == SUB_WRITE_X5)  ||
            (state == AND_WRITE_X6)  ||
            (state == OR_WRITE_X7)   ||
            (state == XOR_WRITE_X8)  ||
            (state == SLL_WRITE_X9)  ||
            (state == SRL_WRITE_X10)
        ) begin

            led_data = ALUResult[15:0];

        end


        // BEQ result
        else if (state == BEQ_CHECK) begin

            led_data = {15'd0, ALUZero};

        end


        // BEQ flag
        else if (state == FLAG_WRITE) begin

            led_data = {15'd0, beq_flag};

        end


        // Read-after-write
        else if (state == READ_AFTER_WRITE) begin

            led_data = ReadData1[15:0];

        end


        // DONE
        else if (state == DONE) begin

            led_data = 16'h0000;

        end

    end


    // =========================================================
    // LED INTERFACE
    // =========================================================

    LEDInterface LED_IF (

        .led_data(led_data),
        .leds(leds)

    );


    // =========================================================
    // SEVEN SEGMENT DISPLAY
    // Displays current RD value
    // =========================================================

    SevenSegment RD_DISPLAY (

        .clk(clk),
        .value(rd),
        .seg(seg),
        .an(an)

    );

endmodule