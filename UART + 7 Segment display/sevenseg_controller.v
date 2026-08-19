module sevenseg_controller(
    input clk,
    input rst,
    input uart_rx,
    output reg [3:0] an,
    output reg [6:0] seg
);
    wire [7:0] rx_data;
    wire rx_ready;
    reg [3:0] digit_reg [0:3];
    reg [1:0] set_index;
    reg set_mode;
    reg [15:0] refresh_counter;
    reg [1:0] current_digit;
    integer idx;

    UART_RX #(.BAUD_DIV(5208)) u_rx (
        .clk(clk), .rst(rst), .rx(uart_rx),
        .data_out(rx_data), .data_valid(rx_ready)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (idx = 0; idx < 4; idx = idx + 1)
                digit_reg[idx] <= 4'd0;
            set_mode <= 1'b0;
            set_index <= 2'd0;
        end else if (rx_ready) begin
            if (set_mode) begin
                if (rx_data >= "0" && rx_data <= "9") begin
                    digit_reg[set_index] <= rx_data - "0";
                    if (set_index == 2'd3)
                        set_mode <= 1'b0;
                    set_index <= set_index + 1'b1;
                end else begin
                    set_mode <= 1'b0;
                end
            end else begin
                case (rx_data)
                    "S": begin set_mode <= 1'b1; set_index <= 2'd0; end
                    "C": for (idx = 0; idx < 4; idx = idx + 1) digit_reg[idx] <= 4'd0;
                    "E": for (idx = 0; idx < 4; idx = idx + 1) digit_reg[idx] <= 4'hE;
                    default: ;
                endcase
            end
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            refresh_counter <= 16'd0;
            current_digit <= 2'd0;
        end else if (refresh_counter == 16'd12500) begin
            refresh_counter <= 16'd0;
            current_digit <= current_digit + 1'b1;
        end else begin
            refresh_counter <= refresh_counter + 1'b1;
        end
    end

    always @(*) begin
        an = ~(4'b0001 << current_digit);
        case (digit_reg[current_digit])
            4'd0: seg = 7'b1000000;
            4'd1: seg = 7'b1111001;
            4'd2: seg = 7'b0100100;
            4'd3: seg = 7'b0110000;
            4'd4: seg = 7'b0011001;
            4'd5: seg = 7'b0010010;
            4'd6: seg = 7'b0000010;
            4'd7: seg = 7'b1111000;
            4'd8: seg = 7'b0000000;
            4'd9: seg = 7'b0010000;
            4'hE: seg = 7'b0000110;
            default: seg = 7'b1111111;
        endcase
    end
endmodule