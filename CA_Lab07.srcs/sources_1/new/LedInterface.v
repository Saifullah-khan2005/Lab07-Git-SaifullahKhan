`timescale 1ns / 1ps

module LEDInterface (
    input  [15:0] led_data,
    output [15:0] leds
);

    assign leds = led_data;

endmodule