module counter(clk, sw, btnC, led);
input	clk;
input [0:0] sw;
input btnC;
output [15:0] 	led;

reg [24:0] 	delay_counter;		//counts to roughly 8 million
wire		twenty_ms_enable=(delay_counter==0);	//one cycle pulse every 8 million cycles
reg [15:0]	led;
reg [1:0]	blink;

reg		btn1;
reg		btn2;

always @(posedge clk) btn1 <= btnC;
always @(posedge clk) btn2 <= btn1;

wire in_click = !btn1 && btn2;

always @(posedge clk)
	if(sw[0:0])		delay_counter <= 0;
	else			delay_counter <= delay_counter+1;

always @(posedge clk)
	if(sw[0:0])			blink <= 0;
	else if(in_click) 		blink <= blink + 1;
	else if(twenty_ms_enable)	blink <= blink + 2;
	else 				blink <= blink;

always @(blink)
	case(blink)
		0:			led <= 16'b0000_0000_0000_0000;
		1:			led <= 16'b0000_0000_0000_1111;
		2:			led <= 16'b0000_0000_1111_1111;
		3:			led <= 16'b0000_0000_1111_0000;
	endcase

endmodule
	
