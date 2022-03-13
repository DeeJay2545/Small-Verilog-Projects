`timescale 1ns / 1ps

module tb ();

reg 		clk;
reg 		btnC;
reg 		btnU;
wire [15:0] 	led;
wire [6:0]	seg;
wire [3:0]	an;


initial clk = 0;
initial forever #5 clk = ~clk;

initial
  begin
			btnC <= 0;
			btnU <= 0;
#2324  			btnC <= 1;
#100			btnC <= 0;
#5000			btnU <= 1;
#500			btnU <= 0;
#5567 			btnC <= 1;
#100			btnC <= 0;
#6000 			btnU <= 1;
#500			btnU <= 0;
#1000  $finish;
  end

always @(led[15])
    $display("LED = %x at time %t", led[15], $time);

reflex reflex 	(
                 .clk(clk),
		 .btnC(btnC),
		 .btnU(btnU),
                 .led(led),
                 .seg(seg),
		 .an(an));


initial 
    $dumpfile("verilog.dmp");

initial
    $dumpvars;


endmodule
