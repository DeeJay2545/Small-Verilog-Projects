module reflex(clk, btnC, btnU, led, seg, an);
input 			    clk;
input 			    btnC;
input 			    btnU;
output [15:0] 		led;
output [6:0]		seg;
output [3:0]		an;

// LED and LED counter
reg [15:0]		    led;
initial			    led = 0;
reg [15:0]		    count;
initial			    count = 0;

// Button pulses + LED change pulse
reg 			     r_btn1;
reg			         r_btn2;
reg			         f_btn1;
reg			         f_btn2;
reg			         led_sw1;
reg			         led_sw2;

// Counters
reg [19:0]		ms_counter;
initial			ms_counter = 0;
reg [30:0]		s_counter;
initial 		s_counter = 0;

// Random number generation
reg [1:0]		ran_num;
initial			ran_num = 0;
reg [2:0]		random;

reg			    done;

// Overall time
reg [3:0]		seconds;
initial 		seconds = 0;
reg [15:0]		miliseconds;
initial			miliseconds = 0;

// Button Press. Both the reset and arm buttons.
always @(posedge clk) r_btn1 <= btnC;
always @(posedge clk) r_btn2 <= r_btn1;

wire ready_click = r_btn1 && !r_btn2;

always @(posedge clk) f_btn1 <= btnU;
always @(posedge clk) f_btn2 <= f_btn1;

wire fire_click = f_btn1 && !f_btn2;

// Done sequence
always @(posedge clk)
	if(ready_click)		      done <= 0;
	else if(fire_click)	      done <= 1;
	else			          done <= done;

// Counter cycles. One timer for miliseconds and another seconds.
wire 	s_tick = s_counter == 30'h5F5E100;              
// wire 		s_tick = s_counter == 8'b1000_0000;					
wire		ms_tick = ms_counter == 20'd100000;             
// wire		ms_tick = ms_counter == 4'b10_00;					

always @(posedge clk) led_sw1 <= led[15];
always @(posedge clk) led_sw2 <= led_sw1;

wire led_change = led_sw1 && !led_sw2;

always @(posedge clk)
	if (s_counter == 30'h5F5E100)	       seconds <= seconds + 1;
	// if (s_counter == 8'b1000_0000)		seconds <= seconds + 1;
	else if (ready_click)			       seconds <= 0;
	else					               seconds <= seconds;

always 	@(posedge clk)
	if (ms_counter == 20'd100000)		    miliseconds <= miliseconds + 1;
	// if ((ms_counter == 4'b10_00) && (!led_change))		miliseconds <= miliseconds + 1;
	else if (led_change)					miliseconds <= 0;
	else							        miliseconds <= miliseconds;

always @(posedge clk)
	if(led_change)		       ms_counter <= 0;
	else if(ms_tick)	       ms_counter <= 0;
	else if(done == 1)	       ms_counter <= ms_counter;
	else			           ms_counter <= ms_counter + 1;

always @(posedge clk)
	if(ready_click)		      s_counter <= 0;
	else if(s_tick)		      s_counter <= 0;
	else if(done == 1)	      s_counter <= s_counter;
	else			          s_counter <= s_counter + 1;

// Random seconds generator
always @(posedge clk)						ran_num <= ran_num + 1;
always @(posedge clk)
	if(ready_click)						    random <= ran_num + 1;
	else							        random <= random; 					

// Turn LED on and off
always @(posedge clk)
	if(ready_click) 					                led[15] <= 0;
	else if((seconds == random) && (random != 0))		led[15] <= 1;
	else							                    led[15] <= led[15];

// Get reaction time
always @(posedge clk)
	if(fire_click) begin
		if(seconds < random)		     		count <= 16'hDEAD;
		else 				     		        count <= miliseconds;
	end
	else if(ready_click)					    count <= 0;
	else					         	        count <= count;

// Check LED
reg [30:0]		test_counter;
initial 		test_counter = 0;

wire 	test_tick = test_counter == 30'h5F5E100;              
// wire 		test_tick = test_counter == 8'b1000_0000;

always @(posedge clk)
	if(test_tick) begin
				            test_counter <= 0;
				            led[0] <= led[0] + 1;
	end
	else			        test_counter <= test_counter + 1;



seg display(.clk(clk), 
	    .count(count), 
	    .reset_click(ready_click),
	    .an(an), 
	    .seg(seg));

endmodule
