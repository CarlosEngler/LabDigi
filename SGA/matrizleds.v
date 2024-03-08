module matrizleds(
input position [3:0],
input apple [3:0],
input clock,
output reg leds [35:0]
);

    initial begin
        [6:0]leds = 7'b1111111;
        [12:11]leds = 2'b11;
        [18:17]leds = 2'b11;
        [24:23]leds = 2'b11;
        [30:29]leds = 2'b11;
        [35]leds = 1'b1;  
    end

    always @ (posedge clock)

    begin
        case (position)
            4'b0000: [7]leds= 1'b1;
            4'b0001: [8] leds = 1'b1;
            4'b0010: [9]leds = 1'b1;
            4'b0011: [10]leds = 1'b1;
            4'b0100: [19]leds = 1'b1;
            4'b0101: [20]leds = 1'b1;
            4'b0110: [21]leds = 1'b1;
            4'b0111: [22]leds = 1'b1;
            4'b1000: [25]leds = 1'b1;
            4'b1001: [26]leds = 1'b1;
            4'b1010: [27]leds = 1'b1;
            4'b1011: [28]leds = 1'b1;
            4'b1100: [31]leds = 1'b1;
            4'b1101: [32]leds = 1'b1;
            4'b1110: [33]leds = 1'b1;
            4'b1111: [34]leds = 1'b1;
        endcase

        case (apple)
            4'b0000: [7]leds= 1'b1;
            4'b0001: [8] leds = 1'b1;
            4'b0010: [9]leds = 1'b1;
            4'b0011: [10]leds = 1'b1;
            4'b0100: [19]leds = 1'b1;
            4'b0101: [20]leds = 1'b1;
            4'b0110: [21]leds = 1'b1;
            4'b0111: [22]leds = 1'b1;
            4'b1000: [25]leds = 1'b1;
            4'b1001: [26]leds = 1'b1;
            4'b1010: [27]leds = 1'b1;
            4'b1011: [28]leds = 1'b1;
            4'b1100: [31]leds = 1'b1;
            4'b1101: [32]leds = 1'b1;
            4'b1110: [33]leds = 1'b1;
            4'b1111: [34]leds = 1'b1;
        endcase
    end







endmodule