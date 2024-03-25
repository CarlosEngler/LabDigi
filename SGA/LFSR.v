module LFSR (
    input clk, 
    input rst, 
    input [3:0] apple,
    output reg [3:0] out);

  wire feedback;

  assign feedback = ~(out[3] ^ out[2]);

always @(posedge clk, posedge rst)
  begin
    if (rst)
      out = 4'b0;
    else if (out == 4'b1000)
      out = 4'b1111;
    else if (out == 4'b1111)
      out = 4'b0000;
    else
      out = {out[2:0],feedback};
  end
endmodule