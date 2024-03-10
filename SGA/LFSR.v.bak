module LFSR (
    input clk,
    input reset,
    output reg [3:0] lfsr_output
);

reg [3:0] lfsr_register;

always @(posedge clk or posedge reset)
begin
    if (reset)
        lfsr_register <= 4'b0001;
    else
        lfsr_register <= {lfsr_register[2:0], lfsr_register[3] ^ lfsr_register[1]};
end

assign lfsr_output = lfsr_register;

endmodule