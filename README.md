UART-Controlled 7-Segment Display
This project implements a UART-controlled, four-digit seven-segment display controller in Verilog. It is designed for an FPGA with a 50 MHz clock and a 9600-baud UART input.

Features
UART receiver for serial input
Commands for setting, clearing, and displaying error status
Four-digit seven-segment display multiplexing
Icarus Verilog testbench
GTKWave waveform output
Project files
uart_rx.v - UART receiver
seg7_decoder.v - BCD-to-seven-segment decoder
sevenseg_controller.v - top-level controller and display multiplexer
tb_sevenseg_controller.v - simulation testbench
waveform.vcd - generated GTKWave waveform file
Requirements
Windows PowerShell, Linux shell, or macOS Terminal
Icarus Verilog (iverilog and vvp)
GTKWave (optional, for viewing waveforms)
Run the simulation
Open a terminal in this directory and run:

iverilog -g2012 -o sim.vvp uart_rx.v seg7_decoder.v sevenseg_controller.v tb_sevenseg_controller.v
vvp sim.vvp
Expected output:

PASS: UART programmed display digits to 1234
The testbench sends the UART sequence S1234 and checks that the four internal display registers contain 1, 2, 3, and 4.

View the waveform in GTKWave
The testbench automatically creates waveform.vcd. Open it with:

gtkwave waveform.vcd
In GTKWave, add clk, uart_rx, digit0, digit1, digit2, and digit3 to the Waves panel. The digit values change in sequence from 0000 to 1234 during the UART transmission.

UART commands
Command	Result
S1234	Set the four display digits to 1234
C	Clear the display to 0000
E	Display EEEE
After sending S, send exactly four ASCII digits. An invalid character exits set mode.

FPGA hardware use
The top-level module is sevenseg_controller:

sevenseg_controller(
	input clk,
	input rst,
	input uart_rx,
	output [3:0] an,
	output [6:0] seg
);
Connect clk, rst, and uart_rx to FPGA pins, and connect an and seg to the four-digit seven-segment display. The display outputs are active-low. The board-specific pin constraints and programming project must be added for the particular FPGA board being used.

Notes
This repository currently contains a simulator-ready Verilog design. It does not include board-specific pin constraints or a Vivado/Quartus project file.

Run the simulation
Install Icarus Verilog, then run these commands from this directory:

iverilog -g2012 -o sim.vvp uart_rx.v seg7_decoder.v sevenseg_controller.v tb_sevenseg_controller.v
vvp sim.vvp
The testbench sends S1234 over UART and prints a PASS message when the four display digits are programmed correctly.
