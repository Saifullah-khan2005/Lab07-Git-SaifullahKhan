`timescale 1ns / 1ps

module RF_ALU_FSM_tb;

    parameter WIDTH = 32;

    reg clk;
    reg rst;

    // Register File controls
    reg WriteEnable;
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;
    reg [WIDTH-1:0] WriteData;

    wire [WIDTH-1:0] ReadData1;
    wire [WIDTH-1:0] ReadData2;

    // ALU controls
    reg A_invert;
    reg B_invert;
    reg CarryIn;
    reg [2:0] Operation;

    wire [WIDTH-1:0] ALUResult;
    wire ALUSet;
    wire ALUOverflow;
    wire ALUZero;


    // =================================================
    // REGISTER FILE
    // =================================================

    RegisterFile RF (
        .clk(clk),
        .rst(rst),
        .WriteEnable(WriteEnable),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .WriteData(WriteData),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );


    // =================================================
    // ALU
    // =================================================

    ALU #(
        .WIDTH(WIDTH)
    ) alu (
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


    // =================================================
    // CLOCK
    // =================================================

    always #5 clk = ~clk;


    // =================================================
    // TEST
    // =================================================

    initial begin

        clk = 0;
        rst = 1;

        WriteEnable = 0;

        rs1 = 0;
        rs2 = 0;
        rd = 0;

        WriteData = 0;

        A_invert = 0;
        B_invert = 0;
        CarryIn = 0;

        Operation = 3'b000;


        // =============================================
        // RESET
        // =============================================

        #10;

        rst = 0;


        // =============================================
        // WRITE x1
        // x1 = 10101010
        // =============================================

        rd = 5'd1;
        WriteData = 32'h1010_1010;
        WriteEnable = 1;

        #10;


        // =============================================
        // WRITE x2
        // x2 = 01010101
        // =============================================

        rd = 5'd2;
        WriteData = 32'h0101_0101;

        #10;


        // =============================================
        // WRITE x3
        // x3 = 5
        // =============================================

        rd = 5'd3;
        WriteData = 32'h0000_0005;

        #10;

        WriteEnable = 0;


        // =============================================
        // READ x1 and x2
        // =============================================

        rs1 = 5'd1;
        rs2 = 5'd2;

        #1;

        $display("---------------------------------------------");
        $display("x1 = %h", ReadData1);
        $display("x2 = %h", ReadData2);


        // =============================================
        // ADD
        // x4 = x1 + x2
        // =============================================

        Operation = 3'b011;
        A_invert = 0;
        B_invert = 0;
        CarryIn = 0;

        #1;

        $display("ADD: %h + %h = %h",
                 ReadData1, ReadData2, ALUResult);


        rd = 5'd4;
        WriteData = ALUResult;
        WriteEnable = 1;

        #10;

        WriteEnable = 0;


        // =============================================
        // SUB
        // x5 = x1 - x2
        // =============================================

        rs1 = 5'd1;
        rs2 = 5'd2;

        Operation = 3'b011;
        A_invert = 0;
        B_invert = 1;
        CarryIn = 1;

        #1;

        $display("SUB: %h - %h = %h",
                 ReadData1, ReadData2, ALUResult);


        rd = 5'd5;
        WriteData = ALUResult;
        WriteEnable = 1;

        #10;

        WriteEnable = 0;


        // =============================================
        // AND
        // x6 = x1 AND x2
        // =============================================

        Operation = 3'b000;
        B_invert = 0;
        CarryIn = 0;

        #1;

        $display("AND: %h & %h = %h",
                 ReadData1, ReadData2, ALUResult);


        rd = 5'd6;
        WriteData = ALUResult;
        WriteEnable = 1;

        #10;

        WriteEnable = 0;


        // =============================================
        // OR
        // x7 = x1 OR x2
        // =============================================

        Operation = 3'b001;

        #1;

        $display("OR: %h | %h = %h",
                 ReadData1, ReadData2, ALUResult);


        rd = 5'd7;
        WriteData = ALUResult;
        WriteEnable = 1;

        #10;

        WriteEnable = 0;


        // =============================================
        // XOR
        // x8 = x1 XOR x2
        // =============================================

        Operation = 3'b010;

        #1;

        $display("XOR: %h ^ %h = %h",
                 ReadData1, ReadData2, ALUResult);


        rd = 5'd8;
        WriteData = ALUResult;
        WriteEnable = 1;

        #10;

        WriteEnable = 0;


        // =============================================
        // SLL
        // x9 = x1 << x3
        // =============================================

        rs1 = 5'd1;
        rs2 = 5'd3;

        Operation = 3'b100;

        #1;

        $display("SLL: %h << %h = %h",
                 ReadData1, ReadData2, ALUResult);


        rd = 5'd9;
        WriteData = ALUResult;
        WriteEnable = 1;

        #10;

        WriteEnable = 0;


        // =============================================
        // SRL
        // x10 = x1 >> x3
        // =============================================

        Operation = 3'b101;

        #1;

        $display("SRL: %h >> %h = %h",
                 ReadData1, ReadData2, ALUResult);


        rd = 5'd10;
        WriteData = ALUResult;
        WriteEnable = 1;

        #10;

        WriteEnable = 0;


        // =============================================
        // BEQ-STYLE TEST
        // Compare x4 with x4
        // =============================================

        rs1 = 5'd4;
        rs2 = 5'd4;

        Operation = 3'b011;
        A_invert = 0;
        B_invert = 1;
        CarryIn = 1;

        #1;

        if (ALUZero)
            $display("BEQ TEST PASS: Values are equal");
        else
            $display("BEQ TEST FAIL");


        // =============================================
        // x0 TEST
        // =============================================

        rs1 = 5'd0;

        #1;

        if (ReadData1 == 0)
            $display("x0 TEST PASS");
        else
            $display("x0 TEST FAIL");


        // =============================================
        // END
        // =============================================

        #10;

        $display("---------------------------------------------");
        $display("INTEGRATED RF + ALU TEST COMPLETE");
        $display("---------------------------------------------");

        $finish;

    end

endmodule