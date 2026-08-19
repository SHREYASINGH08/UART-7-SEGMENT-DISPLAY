# FPGA-Prototyping
UART-Controlled 7-Segment Display System

## Run the simulation

Install Icarus Verilog, then run these commands from this directory:

```powershell
iverilog -g2012 -o sim.vvp uart_rx.v seg7_decoder.v sevenseg_controller.v tb_sevenseg_controller.v
vvp sim.vvp
```

The testbench sends `S1234` over UART and prints a `PASS` message when the
four display digits are programmed correctly.
