module vga_display(
	input                 clk,                //pixel clock
	input                 rst,                //reset signal high active
    input[11:0]                x_pos,         //x position
    input[11:0]                y_pos,         //y position
    input                      video_active,  
	output reg [7:0]           rgb_r,         //video red data
	output reg [7:0]           rgb_g,         //video green data
	output reg [7:0]           rgb_b          //video blue data
);

// 1024*768 
parameter HORI_ACTIVE = 12'd1024;
parameter HORI_FP = 12'd24;      
parameter HORI_SYNCP = 12'd136;   
parameter HORI_BP = 12'd160;     
parameter VERT_ACTIVE = 12'd768; 
parameter VERT_FP  = 12'd3;      
parameter VERT_SYNCP  = 12'd6;    
parameter VERT_BP  = 12'd29;     
parameter HS_POL = 1'b0;
parameter VS_POL = 1'b0;

//define the RGB values for 8 colors
parameter WHITE_R       = 8'hff;
parameter WHITE_G       = 8'hff;
parameter WHITE_B       = 8'hff;
parameter RED_R         = 8'hff;
parameter RED_G         = 8'h00;
parameter RED_B         = 8'h00;
parameter ORANGE_R		= 8'hff;
parameter ORANGE_G		= 8'h61;
parameter ORANGE_B		= 8'h00;
parameter YELLOW_R      = 8'hff;
parameter YELLOW_G      = 8'hff;
parameter YELLOW_B      = 8'h00;                                                               
parameter GREEN_R       = 8'h00;
parameter GREEN_G       = 8'hff;
parameter GREEN_B       = 8'h00;
parameter CYAN_R        = 8'h00;
parameter CYAN_G        = 8'hff;
parameter CYAN_B        = 8'hff; 
parameter BLUE_R        = 8'h00;
parameter BLUE_G        = 8'h00;
parameter BLUE_B        = 8'hff;
parameter PURPLE_R      = 8'ha0;
parameter PURPLE_G      = 8'h20;
parameter PURPLE_B      = 8'hf0;
parameter BLACK_R       = 8'h00;
parameter BLACK_G       = 8'h00;
parameter BLACK_B       = 8'h00;

always@(posedge clk or posedge rst) begin
	if(rst == 1'b1)
		begin
			rgb_r <= 8'h00;
			rgb_g <= 8'h00;
			rgb_b <= 8'h00;
		end
	else if(x_pos >= 1'd0
		   && x_pos <= (12'd128) 
		   && y_pos > 12'd128 )begin
				rgb_r <= PURPLE_R;
				rgb_g <= PURPLE_G;
				rgb_b <= PURPLE_B;
		end
	else
		begin
			rgb_r <= 8'h00;
			rgb_g <= 8'h00;
			rgb_b <= 8'h00;
		end
end

endmodule 


