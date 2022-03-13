module counter (clk, reset, eight_bit_counter);
input          clk;
input          reset;
output  [7:0]  eight_bit_counter;

reg  [7:0]     eight_bit_counter;   


always @(posedge clk)
  if (!reset)            eight_bit_counter <= 0 ;
  else                   eight_bit_counter  <= eight_bit_counter + 1;

endmodule
