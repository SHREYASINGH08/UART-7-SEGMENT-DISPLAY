module UART_RX #(
    parameter BAUD_DIV = 5208
) (
    input clk,
    input rst,
    input rx,
    output reg [7:0] data_out,
    output reg data_valid
);
    reg [12:0] baud_cnt;
    reg [3:0] bit_idx;
    reg [9:0] rx_shift;
    reg busy;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            busy <= 1'b0;
            baud_cnt <= 13'd0;
            bit_idx <= 4'd0;
            rx_shift <= 10'd0;
            data_out <= 8'd0;
            data_valid <= 1'b0;
        end else begin
            data_valid <= 1'b0;
            if (!busy) begin
                if (!rx) begin
                    busy <= 1'b1;
                    baud_cnt <= BAUD_DIV / 2;
                    bit_idx <= 4'd0;
                end
            end else if (baud_cnt == 0) begin
                rx_shift[bit_idx] <= rx;
                baud_cnt <= BAUD_DIV;
                bit_idx <= bit_idx + 1'b1;
                if (bit_idx == 4'd9) begin
                    busy <= 1'b0;
                    data_out <= rx_shift[8:1];
                    data_valid <= 1'b1;
                end
            end else begin
                baud_cnt <= baud_cnt - 1'b1;
            end
        end
    end
endmodule