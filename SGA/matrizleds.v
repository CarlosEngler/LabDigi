module matrizleds(
input [3:0] position,
input [3:0] apple,
input clock,
input restart,
output reg [35:0] leds
);

    initial begin
        leds = 36'd0;
        leds[6:0] = 7'b1111111;
        leds[12:11] = 2'b11;
        leds[18:17] = 2'b11;
        leds[24:23] = 2'b11;
        leds[35:29] = 7'b1111111;
    end

    always @ (clock)

    begin
        case (position)
            4'b0000: leds[7] = 1'b1;
            4'b0001: leds[8] = 1'b1;
            4'b0010: leds[9] = 1'b1;
            4'b0011: leds[10] = 1'b1;
            4'b0100: leds[13] = 1'b1;
            4'b0101: leds[14] = 1'b1;
            4'b0110: leds[15] = 1'b1;
            4'b0111: leds[16] = 1'b1;
            4'b1000: leds[19] = 1'b1;
            4'b1001: leds[20] = 1'b1;
            4'b1010: leds[21] = 1'b1;
            4'b1011: leds[22] = 1'b1;
            4'b1100: leds[25] = 1'b1;
            4'b1101: leds[26] = 1'b1;
            4'b1110: leds[27] = 1'b1;
            4'b1111: leds[28] = 1'b1;
        endcase

        case (apple)
            4'b0000: leds[7] = 1'b1;
            4'b0001: leds[8] = 1'b1;
            4'b0010: leds[9] = 1'b1;
            4'b0011: leds[10] = 1'b1;
            4'b0100: leds[13] = 1'b1;
            4'b0101: leds[14] = 1'b1;
            4'b0110: leds[15] = 1'b1;
            4'b0111: leds[16] = 1'b1;
            4'b1000: leds[19] = 1'b1;
            4'b1001: leds[20] = 1'b1;
            4'b1010: leds[21] = 1'b1;
            4'b1011: leds[22] = 1'b1;
            4'b1100: leds[25] = 1'b1;
            4'b1101: leds[26] = 1'b1;
            4'b1110: leds[27] = 1'b1;
            4'b1111: leds[28] = 1'b1;
        endcase
    end

    always @ (restart) begin
        leds[10:7] = 4'b0000;
        leds[16:13] = 4'b0000;
        leds[22:19] = 4'b0000;
        leds[28:25] = 4'b0000;
    end








endmodule