module sequence(clk, btnC, btnU, sw, led, seg, an);
input 		    clk;
input 		    btnC;
input 		    btnU;
input [1:0]     sw;

output [2:0]	led;
output [3:0]	an;
output [6:0]	seg;
reg [2:0]	    led;

reg [2:0]	    state;
initial 	    state = 0;

reg [15:0]	    count;

reg		        reset1;
reg		        reset2;
wire            reset_click;

reg		        SD1;
reg		        SD2;
reg [31:0]      SD_button_count;
wire            SD_button_done;
wire            SD_click;

parameter DEBOUNCE_DELAY = 32'd0_500_000;   /// 10nS * 1M = 10mS

always @(posedge clk) 					reset1 <= btnC;
always @(posedge clk) 					reset2 <= reset1;
assign 							        reset_click = !reset1 && reset2;

// -----------------------------------------------------------------------------------------//
always @(posedge clk)                   SD1  <= btnU;
always @(posedge clk)                   SD2  <= SD1;

assign                                  SD_button_done = (SD_button_count == DEBOUNCE_DELAY); 
assign                                  SD_click = (SD_button_count == DEBOUNCE_DELAY - 1); 

always @(posedge clk) 
          if (!SD2)                     SD_button_count <= 0;
          else if (SD_button_done)      SD_button_count <= SD_button_count;
          else                          SD_button_count <= SD_button_count + 1;
// -----------------------------------------------------------------------------------------//    
    
always @(posedge clk)
	if(reset_click)					                           state <= 0;
	else if(SD_click) begin	
		case(state)
			3'b000: if(sw == 2'b10)		                        state <= 1;
				else if(sw == 2'b11)	                        state <= 2;
				else			                                state <= state;
			3'b001: if(sw == 2'b10)		                        state <= 4;
				else if(sw == 2'b11)	                        state <= 2;
				else			                                state <= 0;
			3'b010: if(sw == 2'b10)		                        state <= 1;
				else if (sw == 2'b11)	                        state <= 3;
				else			                                state <= 0;
			3'b011: if(sw == 2'b10)		                        state <= 1;
				else if(sw == 2'b11)	                        state <= 6;
				else 			                                state <= 0;
			3'b100: if(sw == 2'b10)		                        state <= state;
				else if(sw == 2'b11)				            state <= 5;
				else			                                state <= 0;
			3'b101: if(sw == 2'b10)		                        state <= 1;
				else if(sw == 2'b11)			                state <= 3;
				else 						                    state <= 0;
			3'b110: if(sw == 2'b10)					            state <= 1;
				else if(sw == 2'b11)				            state <= state;
				else						                    state <= 0;
		endcase
	end
	else						                                state <= state;

always @(posedge clk)					                        led <= state;
always @(posedge clk)
	if((state == 5) || (state == 6))				   	        count <= 16'h1111;
	else 						                                count <= 4'h0;

seg display(.clk(clk), 
	    .count(count), 
	    .reset_click(reset_click),
	    .an(an), 
	    .seg(seg));

endmodule
