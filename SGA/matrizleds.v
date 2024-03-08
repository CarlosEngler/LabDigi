module matrizleds(
input position [3:0],
input apple [3:0],
input clock,
output reg leds [35:0]
);

    initial begin
        leds[6:0] = 7'b1111111;
        leds[12:11] = 2'b11;
        leds[18:17] = 2'b11;
        leds[24:23] = 2'b11;
        leds[30:29] = 2'b11;
        leds[35] = 1'b1;  
    end

    always @ (posedge clock)

    begin
        case (position)
            4'b0000: leds[7] = 1'b1;
            4'b0001: leds[8] = 1'b1;
            4'b0010: leds[9] = 1'b1;
            4'b0011: leds[10] = 1'b1;
            4'b0100: leds[19] = 1'b1;
            4'b0101: leds[20] = 1'b1;
            4'b0110: leds[21] = 1'b1;
            4'b0111: leds[22] = 1'b1;
            4'b1000: leds[25] = 1'b1;
            4'b1001: leds[26] = 1'b1;
            4'b1010: leds[27] = 1'b1;
            4'b1011: leds[28] = 1'b1;
            4'b1100: leds[31] = 1'b1;
            4'b1101: leds[32] = 1'b1;
            4'b1110: leds[33] = 1'b1;
            4'b1111: leds[34] = 1'b1;
        endcase

        case (apple)
            4'b0000: leds[7] = 1'b1;
            4'b0001: leds[8] = 1'b1;
            4'b0010: leds[9] = 1'b1;
            4'b0011: leds[10] = 1'b1;
            4'b0100: leds[19] = 1'b1;
            4'b0101: leds[20] = 1'b1;
            4'b0110: leds[21] = 1'b1;
            4'b0111: leds[22] = 1'b1;
            4'b1000: leds[25] = 1'b1;
            4'b1001: leds[26] = 1'b1;
            4'b1010: leds[27] = 1'b1;
            4'b1011: leds[28] = 1'b1;
            4'b1100: leds[31] = 1'b1;
            4'b1101: leds[32] = 1'b1;
            4'b1110: leds[33] = 1'b1;
            4'b1111: leds[34] = 1'b1;
        endcase
    end







endmodule