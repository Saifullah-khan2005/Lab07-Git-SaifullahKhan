## =========================================================
## Basys 3 Master XDC
## top_rf_alu
## =========================================================


## =========================================================
## CLOCK - 100 MHz
## =========================================================

set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} [get_ports clk]


## =========================================================
## RESET BUTTON - CENTER BUTTON
## =========================================================

set_property PACKAGE_PIN U18 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]


## =========================================================
## SWITCHES
## =========================================================

## SW0
set_property PACKAGE_PIN V17 [get_ports {switches[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switches[0]}]

## SW1
set_property PACKAGE_PIN V16 [get_ports {switches[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switches[1]}]

## SW2
set_property PACKAGE_PIN W16 [get_ports {switches[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switches[2]}]

## SW3
set_property PACKAGE_PIN W17 [get_ports {switches[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switches[3]}]

## SW4
set_property PACKAGE_PIN W15 [get_ports {switches[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switches[4]}]

## SW5
set_property PACKAGE_PIN V15 [get_ports {switches[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switches[5]}]

## SW6
set_property PACKAGE_PIN W14 [get_ports {switches[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switches[6]}]

## SW7
set_property PACKAGE_PIN W13 [get_ports {switches[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switches[7]}]

## SW8
set_property PACKAGE_PIN V2 [get_ports {switches[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switches[8]}]

## SW9
set_property PACKAGE_PIN T3 [get_ports {switches[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switches[9]}]

## SW10
set_property PACKAGE_PIN T2 [get_ports {switches[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switches[10]}]

## SW11
set_property PACKAGE_PIN R3 [get_ports {switches[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switches[11]}]

## SW12
set_property PACKAGE_PIN W2 [get_ports {switches[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switches[12]}]

## SW13
set_property PACKAGE_PIN U1 [get_ports {switches[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switches[13]}]

## SW14
set_property PACKAGE_PIN T1 [get_ports {switches[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switches[14]}]

## SW15
set_property PACKAGE_PIN R2 [get_ports {switches[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switches[15]}]


## =========================================================
## LEDS
## =========================================================

## LED0
set_property PACKAGE_PIN U16 [get_ports {leds[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[0]}]

## LED1
set_property PACKAGE_PIN E19 [get_ports {leds[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[1]}]

## LED2
set_property PACKAGE_PIN U19 [get_ports {leds[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[2]}]

## LED3
set_property PACKAGE_PIN V19 [get_ports {leds[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[3]}]

## LED4
set_property PACKAGE_PIN W18 [get_ports {leds[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[4]}]

## LED5
set_property PACKAGE_PIN U15 [get_ports {leds[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[5]}]

## LED6
set_property PACKAGE_PIN U14 [get_ports {leds[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[6]}]

## LED7
set_property PACKAGE_PIN V14 [get_ports {leds[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[7]}]

## LED8
set_property PACKAGE_PIN V13 [get_ports {leds[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[8]}]

## LED9
set_property PACKAGE_PIN V3 [get_ports {leds[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[9]}]

## LED10
set_property PACKAGE_PIN W3 [get_ports {leds[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[10]}]

## LED11
set_property PACKAGE_PIN U3 [get_ports {leds[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[11]}]

## LED12
set_property PACKAGE_PIN P3 [get_ports {leds[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[12]}]

## LED13
set_property PACKAGE_PIN N3 [get_ports {leds[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[13]}]

## LED14
set_property PACKAGE_PIN P1 [get_ports {leds[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[14]}]

## LED15
set_property PACKAGE_PIN L1 [get_ports {leds[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[15]}]


## =========================================================
## BASYS 3 SEVEN SEGMENT DISPLAY
## =========================================================

## Segment A
set_property PACKAGE_PIN W7 [get_ports {seg[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]

## Segment B
set_property PACKAGE_PIN W6 [get_ports {seg[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]

## Segment C
set_property PACKAGE_PIN U8 [get_ports {seg[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]

## Segment D
set_property PACKAGE_PIN V8 [get_ports {seg[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]

## Segment E
set_property PACKAGE_PIN U5 [get_ports {seg[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]

## Segment F
set_property PACKAGE_PIN V5 [get_ports {seg[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]

## Segment G
set_property PACKAGE_PIN U7 [get_ports {seg[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]


## =========================================================
## SEVEN SEGMENT DIGIT ENABLE
## =========================================================

## Rightmost digit
set_property PACKAGE_PIN U2 [get_ports {an[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]

## Second digit
set_property PACKAGE_PIN U4 [get_ports {an[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]

## Disable unused digits
set_property PACKAGE_PIN V4 [get_ports {an[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]

set_property PACKAGE_PIN W4 [get_ports {an[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]