module LFSR (
    input clk, 
    input rst, 
    output reg [5:0] out);

  wire feedback;

  assign feedback = out[5] ^ out[0];

always @(posedge clk, posedge rst)
  begin
    if (rst)
      out = 6'b000001;
    else
      out = {feedback, out[5:1]};
  end
 
endmodule