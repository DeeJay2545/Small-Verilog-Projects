module counter (clk, reset, counter, ms_tick, flip);
input          clk;
input          reset;
output 	 	ms_tick;
output  [3:0]  counter;
output 		flip;

reg  [3:0]     counter;   // 17 bits for 128k counting at 100MHz
wire           ms_tick = counter >= 4'h6 && counter <= 4'h9;
reg flip;



always @(posedge clk)
  if (!reset)  begin        
	counter <= 0;
	flip <= 0;
  end

  else begin
	if (counter == 4'hf) begin
		flip = 1;
	end
	
	else if (counter == 4'h0) begin
		flip = 0;
	end

	else begin 
		flip = flip;
	end
/* -------------------------------------------------- */

	if (flip == 1) begin 
		counter = counter - 1;
	end
	
	else 
		counter = counter + 1;

  end
endmodule
