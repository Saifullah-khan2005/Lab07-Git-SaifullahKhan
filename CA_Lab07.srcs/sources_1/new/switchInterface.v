`timescale 1ns / 1ps

module SwitchInterface (
    input  [15:0] switches,
    output [15:0] switch_value
);

    assign switch_value = switches;

endmodule