`timescale 1ns / 1ps

module SevenSegment (

    input        clk,
    input  [4:0] value,

    output reg [6:0] seg,
    output reg [3:0] an

);

    // Refresh counter
    reg [15:0] refresh_counter;

    // Which digit is currently active
    reg digit_select;

    // Current hexadecimal digit
    reg [3:0] digit;


    // =========================================================
    // DISPLAY REFRESH
    // =========================================================

    always @(posedge clk) begin

        refresh_counter <= refresh_counter + 1'b1;

    end


    // Use one counter bit to switch between two digits
    always @(*) begin

        digit_select = refresh_counter[15];

    end


    // =========================================================
    // SELECT DIGIT
    //
    // rd is 5 bits:
    //
    // rd = 0  -> 00
    // rd = 1  -> 01
    // rd = 10 -> 0A
    // rd = 12 -> 0C
    // rd = 31 -> 1F
    // =========================================================

    always @(*) begin

        if (digit_select == 1'b0) begin

            // Right digit = lower 4 bits
            an = 4'b1110;

            digit = value[3:0];

        end

        else begin

            // Left digit = bit 4
            an = 4'b1101;

            digit = {3'b000, value[4]};

        end

    end


    // =========================================================
    // HEX TO 7-SEGMENT DECODER
    //
    // Basys 3 seven-segment display is active LOW
    // =========================================================

    always @(*) begin

        case (digit)

            4'h0: seg = 7'b1000000;
            4'h1: seg = 7'b1111001;
            4'h2: seg = 7'b0100100;
            4'h3: seg = 7'b0110000;
            4'h4: seg = 7'b0011001;
            4'h5: seg = 7'b0010010;
            4'h6: seg = 7'b0000010;
            4'h7: seg = 7'b1111000;
            4'h8: seg = 7'b0000000;
            4'h9: seg = 7'b0010000;

            4'hA: seg = 7'b0001000;
            4'hB: seg = 7'b0000011;
            4'hC: seg = 7'b1000110;
            4'hD: seg = 7'b0100001;
            4'hE: seg = 7'b0000110;
            4'hF: seg = 7'b0001110;

            default:
                seg = 7'b1111111;

        endcase

    end

endmodule