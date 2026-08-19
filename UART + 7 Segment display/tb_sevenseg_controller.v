`timescale 1ns/1ps

module tb_sevenseg_controller;
    reg clk = 1'b0;
    reg rst = 1'b1;
    reg uart_rx = 1'b1;
    wire [3:0] an;
    wire [6:0] seg;
    wire [3:0] digit0 = uut.digit_reg[0];
    wire [3:0] digit1 = uut.digit_reg[1];
    wire [3:0] digit2 = uut.digit_reg[2];
    wire [3:0] digit3 = uut.digit_reg[3];
    integer i;

    sevenseg_controller uut (
        .clk(clk), .rst(rst), .uart_rx(uart_rx), .an(an), .seg(seg)
    );

    always #10 clk = ~clk;

    task uart_send_byte(input [7:0] data);
        begin
            uart_rx = 1'b0; #(104167);
            for (i = 0; i < 8; i = i + 1) begin
                uart_rx = data[i]; #(104167);
            end
            uart_rx = 1'b1; #(104167);
        end
    endtask

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_sevenseg_controller);
        #(200000); rst = 1'b0;
        uart_send_byte("S");
        uart_send_byte("1");
        uart_send_byte("2");
        uart_send_byte("3");
        uart_send_byte("4");
        #(104167 * 20);
        if (uut.digit_reg[0] !== 4'd1 || uut.digit_reg[1] !== 4'd2 ||
            uut.digit_reg[2] !== 4'd3 || uut.digit_reg[3] !== 4'd4)
            $fatal(1, "UART digit programming failed");
        $display("PASS: UART programmed display digits to 1234");
        $finish;
    end
endmodule