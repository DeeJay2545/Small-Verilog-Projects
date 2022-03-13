`timescale 1ns / 1ps

module tb ();

reg clk;
reg reset;
wire [7:0] led;


initial clk = 0;
initial forever #5 clk = ~clk;

initial
  begin
         reset <= 0;
#1000    reset <= 1;
#6000    $display("made it to 6000 @ %t", $time);
#10000   $finish;
  end

always @(led)
    $display("led = %x at time %t", led, $time);

counter counter (
                 .clk(clk),
                 .reset(reset),
                 .led(led));


initial 
    $dumpfile("verilog.dmp");

initial
    $dumpvars;


endmodule
