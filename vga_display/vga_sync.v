// generate sync signals & display
module vga_sync(
	input                 clk,           //pixel clock
	input                 rst,           //reset signal high active
	output                h_pulse,        //horizontal synchronization pulse
	output                v_pulse,        //vertical synchronization pulse
	output                video_valid,    //video valid
	output reg [11:0]     x_pos,     //x position
    output reg [11:0]     y_pos      //Y position
);

//define vga mode related resolution parameters

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

parameter HORI_WHOLE = HORI_ACTIVE + HORI_FP + HORI_SYNCP + HORI_BP; //horizontal (pixels) whole line 
parameter VERT_WHOLE = VERT_ACTIVE + VERT_FP + VERT_SYNCP + VERT_BP; //vertical (lines) whole frame

reg [15:0] h_counter;             //horizontal counter
reg [15:0] v_counter;             //vertical counter

wire h_valid;                    //horizontal valid active zone 
wire v_valid;                    //vertical valid active zone              

always@(posedge clk or posedge rst)
begin
	if(rst == 1'b1)
		h_counter <= 0;
	else if(h_counter == HORI_WHOLE - 1)
		h_counter <= 0;
	else
		h_counter <= h_counter + 1; //h counter ++ after one pixel done
end

always@(posedge clk or posedge rst)
begin
	if(rst == 1'b1)
		v_counter <= 0;
	else if(h_counter == HORI_WHOLE - 1)begin //v counter ++ only after one row done
		if(v_counter == VERT_WHOLE - 1)begin 
			v_counter <= 0;
		end
		else begin
		v_counter <= v_counter + 1;
		end 
	end
	else begin
		v_counter <= v_counter;
	end
end 

assign h_pulse = ((h_counter >= HORI_FP + HORI_SYNCP - 1) || (h_counter < HORI_FP - 1))? 1'b1:1'b0;
assign v_pulse = ((v_counter >= VERT_FP + VERT_SYNCP - 1) || (v_counter < VERT_FP - 1))? 1'b1:1'b0;
assign h_valid = ((h_counter >= HORI_FP + HORI_SYNCP + HORI_BP - 1) && (h_counter < HORI_WHOLE - 1)) ? 1'b1:1'b0;
assign v_valid = ((v_counter >= VERT_FP + VERT_SYNCP + VERT_BP - 1) && (v_counter < VERT_WHOLE - 1)) ? 1'b1:1'b0;
assign video_valid = h_valid & v_valid;

//get x/y positions
always@(posedge clk or posedge rst)
begin
	if(rst == 1'b1)
		x_pos <= 0;
	else if(h_counter >= HORI_FP + HORI_SYNCP + HORI_BP - 1)
		x_pos <= h_counter - (HORI_FP + HORI_SYNCP + HORI_BP - 1); //current total counts - blanking counts
	else
		x_pos <= x_pos;
end

always@(posedge clk or posedge rst)
begin
	if(rst == 1'b1)
		y_pos <= 0;
	else if(v_counter >= VERT_FP + VERT_SYNCP + VERT_BP - 1)
		y_pos <= v_counter - (VERT_FP + VERT_SYNCP + VERT_BP - 1); //current total counts - blanking counts
	else
		y_pos <= y_pos;
end

endmodule