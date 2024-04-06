module TB_LFSR;
  reg clk, reset;
  wire [5:0] lfsr_output;
  
  LFSR lfsr1(clk, reset, lfsr_output);
  
  initial begin
    $monitor("lfsr_output=%b",lfsr_output);
    clk = 0; reset = 1;
    #5 reset = 0;
    #200; $finish;
  end
  
  always #2 clk=~clk;
  
  initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule