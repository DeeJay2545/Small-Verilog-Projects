module sequence(clk, btnC, btnU, sw, state_output);
input 		    clk;
input 		    btnC;
input 		    btnU;
input [1:0]         sw;
output		    state_output;

reg [2:0]	    state;
initial 	    state = 0;

reg		    reset1;
reg		    reset2;
wire                reset_click;

reg		    SD1;
reg		    SD2;
wire                SD_click;

always @(posedge clk) 					reset1 <= btnC;
always @(posedge clk) 					reset2 <= reset1;
assign 							reset_click = !reset1 && reset2;

always @(posedge clk) 					SD1 <= btnU;
always @(posedge clk) 					SD2 <= SD1;
assign 							SD_click = !SD1 && SD2;
  
wire 							state_output = ((state == 5) || (state == 6));
  
always @(posedge clk)
	if(reset_click)					                        state <= 0;
	else if(SD_click) begin	
		case(state)
			3'b000: if(sw == 2'b10)		                        state <= 1;
				else if(sw == 2'b11)	                        state <= 2;
				else			                        state <= state;
			3'b001: if(sw == 2'b10)		                        state <= 4;
				else if(sw == 2'b11)	                        state <= 2;
				else			                        state <= 0;
			3'b010: if(sw == 2'b10)		                        state <= 1;
				else if (sw == 2'b11)	                        state <= 3;
				else			                        state <= 0;
			3'b011: if(sw == 2'b10)		                        state <= 1;
				else if(sw == 2'b11)	                        state <= 6;
				else 			                        state <= 0;
			3'b100: if(sw == 2'b10)		                        state <= state;
				else if(sw == 2'b11)				state <= 5;
				else			                        state <= 0;
			3'b101: if(sw == 2'b10)		                        state <= 1;
				else if(sw == 2'b11)			        state <= 3;
				else 						state <= 0;
			3'b110: if(sw == 2'b10)					state <= 1;
				else if(sw == 2'b11)				state <= state;
				else						state <= 0;
		endcase
	end
	else						                        state <= state;

endmodule
