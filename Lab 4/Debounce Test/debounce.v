module debounce(clk, btnU, add_click);
input 		clk;
input 		btnU;
output		add_click;
reg		add_reg1;
reg		add_reg2;
reg [31:0]    	add_button_count;
wire    	add_button_done;
wire    	add_click;

parameter DEBOUNCE_DELAY = 32'd0_500_000;   /// 10nS * 1M = 10mS

always @(posedge clk)   add_reg1   <= btnU;
always @(posedge clk)   add_reg2  <= add_reg1;

assign                        add_button_done  = (add_button_count == DEBOUNCE_DELAY); 
assign                        add_click = (add_button_count == DEBOUNCE_DELAY - 1); 

always @(posedge clk) 
          if (!add_reg2)                    add_button_count <= 0;
          else if (add_button_done)         add_button_count <= add_button_count;
          else                              add_button_count <= add_button_count + 1;

endmodule
