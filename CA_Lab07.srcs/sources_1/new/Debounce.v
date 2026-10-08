`timescale 1ns / 1ps

module Debounce #(
    parameter COUNT_MAX = 2_000_000
)(
    input  clk,
    input  btn_in,
    output reg btn_out
);

    reg btn_sync1;
    reg btn_sync2;

    reg [20:0] count;

    always @(posedge clk) begin

        // Synchronize button
        btn_sync1 <= btn_in;
        btn_sync2 <= btn_sync1;

        if (btn_sync2) begin

            if (count < COUNT_MAX) begin
                count <= count + 1;
            end

            else begin
                btn_out <= 1'b1;
            end

        end

        else begin
            count <= 0;
            btn_out <= 1'b0;
        end

    end

endmodule