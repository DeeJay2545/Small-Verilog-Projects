`timescale 1ns / 1ps

module tb ();

reg clk;
reg btnC;
reg btnU;
reg [1:0] sw;
wire state_output;


initial clk = 0;
initial forever #5 clk = ~clk;

initial
  begin
#10	 btnC <= 0;
#10	 btnU <= 0;       
#1000    sw[1:0] <= 3;
#1000	 btnU <= 1;
#10	 btnU <= 0;
#1000	 sw[1:0] <= 3;
#1000	 btnU <= 1;
#10	 btnU <= 0;
#1000	 sw[1:0] <= 3;
#1000	 btnU <= 1;
#10	 btnU <= 0;
#1000	 sw[1:0] <= 1;
#1000	 btnU <= 1;
#10	 btnU <= 0;
#1000	 sw[1:0] <= 2;
#1000	 btnU <= 1;
#10	 btnU <= 0;
#1000	 sw[1:0] <= 2;
#1000	 btnU <= 1;
#10	 btnU <= 0;
#1000	 sw[1:0] <= 3;
#1000	 btnU <= 1;
#10	 btnU <= 0;
#1000	 sw[1:0] <= 3;
#1000	 btnU <= 1;
#10	 btnU <= 0;
#1000	 sw[1:0] <= 3;
#1000	 btnU <= 1;
#10	 btnU <= 0;
#1000	 sw[1:0] <= 3;
#1000	 btnC <= 1;
#10	 btnC <= 0;
#5000    $finish;
  end

always @(state_output)
    $display("Output = %x at time %t", state_output, $time);

sequence sequence (
                 .clk(clk),
		 .btnC(btnC),
		 .btnU(btnU),
                 .sw(sw),
                 .state_output(state_output));


initial 
    $dumpfile("verilog.dmp");

initial
    $dumpvars;


endmodule
