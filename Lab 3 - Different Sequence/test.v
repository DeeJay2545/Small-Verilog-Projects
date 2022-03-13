module counter(clk, sw, btnC, led);
input	clk;
input [0:0] sw;
input btnC;
output [7:0] 	led;

reg [24:0] 	delay_counter;		//counts to roughly 8 million
wire		twenty_ms_enable=(delay_counter==0);	//one cycle pulse every 8 million cycles
reg [7:0]	led;
reg [0:0] 	state;

reg [4:0]	s1;

reg [3:0]	counter;
initial 	counter = 0;
reg [1:0]	step;
initial 	step = 0;

reg		btn1;
reg		btn2;

always @(posedge clk) btn1 <= btnC;
always @(posedge clk) btn2 <= btn1;

wire in_click = !btn1 && btn2;

always @(posedge clk)
	if(sw[0:0])		delay_counter <= 0;
	else			delay_counter <= delay_counter+1;

always @(posedge clk)
	if(sw[0:0]) begin
			s1 <= 0;
			state <= 0;
	end
	
	else if(in_click) begin
		state <= state + 1;
		if (state == 0) begin
			s1 <= 13;
			step <= 0;
			counter <= 1;
		end
		else 	s1 <= 0;
	end

	else if(twenty_ms_enable && !state) begin
		if(s1 == 12)	    s1 <= 0;
		else		    s1 <= s1 + 1;
	end

	else if(twenty_ms_enable && state) begin	
		if (step == 0) begin
			s1 <= s1 + counter;
			step <= step + 1;
		end

		else if (step == 1) begin
			s1 <= s1 - counter;
			step <= step + 1;
		end

		else if (step == 2) begin
			s1 <= s1 + counter;
			step <= step + 1;
		end

		else begin	
			s1 <= 13;
			step <= step + 1;
			if (counter == 8)	counter <= 1;
			else 			counter <= counter + 1;
		end
	end

	else begin
		s1 <= s1;
	end
		

always @(s1)
	case(s1)
		0:			led <= 8'b0000_0001;
		1:			led <= 8'b0000_0100;
		2:			led <= 8'b0000_0010;
		3:			led <= 8'b0000_1000;
		4:			led <= 8'b0000_0100;
		5:			led <= 8'b0001_0000;
		6:			led <= 8'b0010_0000;
		7:			led <= 8'b0000_1000;
		8:			led <= 8'b0010_0000;
		9:			led <= 8'b0001_0000;
		10:			led <= 8'b0100_0000;
		11:			led <= 8'b0010_0000;
		12:			led <= 8'b1000_0000;
		13:			led <= 8'b0000_0000;
		14:			led <= 8'b0000_0001;
		15:			led <= 8'b0000_0010;
		16:			led <= 8'b0000_0100;
		17:			led <= 8'b0000_1000;
		18:			led <= 8'b0001_0000;
		19:			led <= 8'b0010_0000;
		20:			led <= 8'b0100_0000;
		21:			led <= 8'b1000_0000;
	endcase

endmodule
	
