module counter(clk, btnC, btnU, btnD, an, seg, count);
input 		clk;
input 		btnC;
input 		btnU;
input 		btnD;
output [3:0]	an;
output [6:0]	seg;
output [15:0]   count;
 
reg [3:0]	an;
reg [6:0]	seg;

reg   [15:0]    count;   // 16 bit number to be displayed

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


reg   [39:0]                      counter;
always @(posedge clk)             
	if(reset_click)               counter     <= 0;
	else                          counter     <= counter + 1;
                                  
wire                              anode_clk    =  (counter[15:0] == 16'h8000);


always @(posedge clk)
        if(reset_click)       an <= 4'b0111;	
	     else if(anode_clk)   an <= {an[0],an[3:1]}; // rotate
	     else                 an <=  an;  

reg [3:0] cathode_select;

always @(an or count)
       case({an})
	      4'b0111:  cathode_select = count[15:12]; 
	      4'b1011:  cathode_select = count[11:8]; 
	      4'b1101:  cathode_select = count[7:4]; 
	      4'b1110:  cathode_select = count[3:0];
	      default:  cathode_select = 4'h0; 
      endcase


always @(cathode_select)
       case(cathode_select)
	       4'h0:  seg = 7'b1000_000;
	       4'h1:  seg = 7'b1111_001;
	       4'h2:  seg = 7'b0100_100;
	       4'h3:  seg = 7'b0110_000;
	       4'h4:  seg = 7'b0011_001;
	       4'h5:  seg = 7'b0010_010;
	       4'h6:  seg = 7'b0000_011;
	       4'h7:  seg = 7'b1111_000;
	       4'h8:  seg = 7'b0000_000;
	       4'h9:  seg = 7'b0011_000; 
	       4'ha:  seg = 7'b0001_000;
	       4'hb:  seg = 7'b0000_011; 
	       4'hc:  seg = 7'b1000_110; 
	       4'hd:  seg = 7'b0100_001; 
	       4'he:  seg = 7'b0000_110; 
	       4'hf:  seg = 7'b0001_110; 
     endcase
       
endmodule
