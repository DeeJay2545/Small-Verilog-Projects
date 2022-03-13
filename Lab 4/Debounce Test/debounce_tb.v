`timescale 1ns / 1ps

module tb ();

reg clk;
reg btnU;
wire add_click;


initial clk = 0;
initial forever #5 clk = ~clk;

initial
  begin

#1000 
#6000    $display("made it to 6000 @ %t", $time);
#5000 	 btnU <= 1;
#1000    btnU <= 0;
#1000    btnU <= 1;
#10000000 	 btnU <= 0;
#5000   $finish;
  end

always @(add_click)
    $display("Change at time %t", $time);

debounce debounce (
                 .clk(clk),
		 .btnU(btnU),
                 .add_click(add_click));


initial 
    $dumpfile("verilog.dmp");

initial
    $dumpvars;

endmodule
