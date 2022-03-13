module counter (clk, sw, led);
input          clk;
input  [0:0]   sw;
output [7:0] led;

reg [63:0] counter;
wire [7:0] led = counter[31:24];


always @(posedge clk)
    if (sw[0:0])     counter <= 0;
    else            counter <= counter + 1;

endmodule
