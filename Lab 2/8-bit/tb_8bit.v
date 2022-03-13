`timescale 1ns / 1ps

module tb ();

reg clk;
reg reset;
wire [7:0] eight_bit_counter;


initial clk = 0;
initial forever #5 clk = ~clk;

initial
  begin
         reset <= 0;
#1000    reset <= 1;
#6000    $display("made it to 6000 @ %t", $time);

#5000    $finish;
  end

always @(eight_bit_counter)
    $display("counter = %x at time %t", eight_bit_counter, $time);

counter counter (
                 .clk(clk),
                 .reset(reset),
                 .eight_bit_counter(eight_bit_counter));


initial 
    $dumpfile("verilog.dmp");

initial
    $dumpvars;


endmodule
