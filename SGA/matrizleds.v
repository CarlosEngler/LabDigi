module matrizleds(
input [5:0] position,
input [5:0] apple,
input clock,
input restart,
output reg [99:0] leds
);

    initial begin
        leds = 100'd0;
        leds[10:0] = 11'b11111111111;
        leds[20:19] = 2'b11;
        leds[30:29] = 2'b11;
        leds[40:39] = 2'b11;
		leds[50:49] = 2'b11;
		leds[60:59] = 2'b11;
		leds[70:69] = 2'b11;
		leds[80:70] = 2'b11;
		leds[90:89] = 2'b11;
		leds[100:91] = 11'b11111111111;
    end

    always @ (clock) begin
	     if (restart) begin
			  leds[10:9]  <= 8'd0;
			  leds[16:13] <= 8'd0;
			  leds[22:19] <= 8'd0;
			  leds[28:25] <= 8'd0;
			  leds[28:25] <= 8'd0;
			  leds[28:25] <= 8'd0;
			  leds[28:25] <= 8'd0;
			  leds[28:25] <= 8'd0;
			  leds[28:25] <= 8'd0;
		  end
		  else begin
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
    end




endmodule