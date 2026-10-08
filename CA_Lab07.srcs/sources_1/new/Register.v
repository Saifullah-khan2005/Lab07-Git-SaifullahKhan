`timescale 1ns / 1ps

module RegisterFile #(
    parameter WIDTH = 32,
    parameter REG_COUNT = 32
)(
    input                   clk,
    input                   rst,
    input                   WriteEnable,

    input  [4:0]            rs1,
    input  [4:0]            rs2,
    input  [4:0]            rd,

    input  [WIDTH-1:0]      WriteData,

    output [WIDTH-1:0]      ReadData1,
    output [WIDTH-1:0]      ReadData2
);

    // 32 registers, each 32 bits
    reg [WIDTH-1:0] regs [0:REG_COUNT-1];

    integer i;

    // Synchronous write
    always @(posedge clk) begin

        if (rst) begin

            // Reset all registers
            for (i = 0; i < REG_COUNT; i = i + 1) begin
                regs[i] <= {WIDTH{1'b0}};
            end

        end

        else begin

            // Never allow writing to x0
            if (WriteEnable && (rd != 5'd0)) begin
                regs[rd] <= WriteData;
            end

            // x0 must always remain zero
            regs[0] <= {WIDTH{1'b0}};
        end

    end

    // Asynchronous read port 1
    assign ReadData1 = (rs1 == 5'd0) ?
                       {WIDTH{1'b0}} :
                       regs[rs1];

    // Asynchronous read port 2
    assign ReadData2 = (rs2 == 5'd0) ?
                       {WIDTH{1'b0}} :
                       regs[rs2];

endmodule