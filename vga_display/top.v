module top(
	//input
	input                       CLOCK_50,	//clk_50m
	input[3:0]                  KEY,	    //asynchronous active low reset
	//vga output
	output                      VGA_CLK,	//pixel_clk   
	output                      VGA_HS, //vga horizontal synchronization         
	output                      VGA_VS, //vga vertical synchronization                  
	output[7:0]                 VGA_R,  //vga red
	output[7:0]                 VGA_G,  //vga green
	output[7:0]                 VGA_B,   //vga blue

	//output[31:0]				vga_row,     //y pixel coordinate; 0 = top row
	//output[31:0]				vga_col,     //x pixel coordinate; 0 = leftmost

	output                      VGA_BLANK_N, //direct blanking
	output                      VGA_SYNC_N  //sync-on-green
	
);

reg                             video_clk;
wire                            video_h_pulse;
wire                            video_v_pulse;
wire                            video_valid;
wire[7:0]                       video_r;
wire[7:0]                       video_g;
wire[7:0]                       video_b;

assign VGA_HS = video_h_pulse;
assign VGA_VS = video_v_pulse;
assign VGA_R  = video_r[7:0]; 
assign VGA_G  = video_g[7:0]; 
assign VGA_B  = video_b[7:0]; 

assign VGA_BLANK_N = 1'b1; // 1 for no use
assign VGA_CLK = video_clk;
assign VGA_SYNC_N = 1'b0; // 0 for no use

//generate video pixel clock
pll pll_test(
		.refclk(CLOCK_50),   //  refclk.clk
		.rst(~KEY[0]),      //   reset.reset
		.outclk_0(video_clk)  // outclk0.clk
	);

// reg video_clk=1'b0;
// always @(posedge clk)begin
// 	video_clk = ~video_clk;
// end

wire[11:0] x_pos;
wire[11:0] y_pos;

vga_sync video_sync_test1(
	.clk(video_clk),
	.rst(0),
	.h_pulse(video_h_pulse),
	.v_pulse(video_v_pulse),
	.video_valid(video_valid),
	.x_pos(x_pos),
	.y_pos(y_pos)
);

vga_display video_display_test1(
	.clk(video_clk),
	.rst(~KEY[2]),
	.x_pos(x_pos),
	.y_pos(y_pos),
	.video_active(video_valid),
	.rgb_r(video_r),
	.rgb_g(video_g),
	.rgb_b(video_b)
);
endmodule

