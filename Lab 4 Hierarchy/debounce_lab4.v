module counter(clk, btnC, btnU, btnD, an, seg, count);
input 		clk;
input 		btnC;
input 		btnU;
input 		btnD;
output [3:0]    an;
output [6:0]	seg;
output [15:0]   count;

reg [15:0]    	count;   // 16 bit number to be displayed

reg		add_reg1;
reg		add_reg2;
reg [31:0]      add_button_count;
wire            add_button_done;
wire            add_click;

reg		sub_reg1;
reg		sub_reg2;
reg [31:0]      sub_button_count;
wire            sub_button_done;
wire            sub_click;

reg		reset_reg1;
reg		reset_reg2;
reg [31:0]      reset_button_count;
wire            reset_button_done;
wire            reset_click;

parameter DEBOUNCE_DELAY = 32'd0_500_000;   /// 10nS * 1M = 10mS




// ------------------------------------------------------------------- // 

always @(posedge clk)   add_reg1   <= btnU;
always @(posedge clk)   add_reg2  <= add_reg1;

assign                        add_button_done  = (add_button_count == DEBOUNCE_DELAY); 
assign                        add_click = (add_button_count == DEBOUNCE_DELAY - 1); 

always @(posedge clk) 
          if (!add_reg2)                    add_button_count <= 0;
          else if (add_button_done)         add_button_count <= add_button_count;
          else                              add_button_count <= add_button_count + 1;

// --------------------------------------------------------------------- //

always @(posedge clk)   sub_reg1   <= btnD;
always @(posedge clk)   sub_reg2  <= sub_reg1;

assign                        sub_button_done  = (sub_button_count == DEBOUNCE_DELAY); 
assign                        sub_click = (sub_button_count == DEBOUNCE_DELAY - 1); 

always @(posedge clk) 
          if (!sub_reg2)                    sub_button_count <= 0;
          else if (sub_button_done)         sub_button_count <= sub_button_count;
          else                              sub_button_count <= sub_button_count + 1;
          
// --------------------------------------------------------------------- //

always @(posedge clk)   reset_reg1   <= btnC;
always @(posedge clk)   reset_reg2  <= reset_reg1;

assign                        reset_button_done  = (reset_button_count == DEBOUNCE_DELAY); 
assign                        reset_click = (reset_button_count == DEBOUNCE_DELAY - 1); 

always @(posedge clk) 
          if (!reset_reg2)                    reset_button_count <= 0;
          else if (reset_button_done)         reset_button_count <= reset_button_count;
          else                                reset_button_count <= reset_button_count + 1;
          
// --------------------------------------------------------------------- //

always @(posedge clk)
	if(reset_click)		count = 0;
	else if(add_click)	count = count + 1;
	else if(sub_click)	count = count - 1;
	else 			    count = count;

seg display(.clk(clk), 
	    .count(count), 
	    .reset_click(reset_click),
	    .an(an), 
	    .seg(seg));


endmodule
