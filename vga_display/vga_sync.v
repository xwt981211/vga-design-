// generate sync signals & display
module vga_sync(
	input                 clk,           //pixel clock
	input                 rst,           //reset signal high active
	output                h_pulse,        //horizontal synchronization pulse
	output                v_pulse,        //vertical synchronization pulse
	output                video_valid,    //video valid
	output reg [11:0]         x_pos,     //x position
    output reg [11:0]         y_pos      //Y position
);

//define vga mode related resolution parameters

// 1024*768 65mhz
parameter HORI_ACTIVE = 16'd1024;
parameter HORI_FP = 16'd24;      
parameter HORI_SYNCP = 16'd136;   
parameter HORI_BP = 16'd160;     
parameter VERT_ACTIVE = 16'd768; 
parameter VERT_FP  = 16'd3;      
parameter VERT_SYNCP  = 16'd6;    
parameter VERT_BP  = 16'd29;     
parameter HS_POL = 1'b0;
parameter VS_POL = 1'b0;

parameter HORI_WHOLE = HORI_ACTIVE + HORI_FP + HORI_SYNCP + HORI_BP; //horizontal (pixels) whole line 
parameter VERT_WHOLE = VERT_ACTIVE + VERT_FP + VERT_SYNCP + VERT_BP; //vertical (lines) whole frame

reg [15:0] h_counter;             //horizontal counter
reg [15:0] v_counter;             //vertical counter
wire h_active;                    //horizontal video active
wire v_active;                    //vertical video active
wire video_active;               //video active(horizontal active and vertical active)

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
assign h_active = ((h_counter >= HORI_FP + HORI_SYNCP + HORI_BP - 1) && (h_counter < HORI_WHOLE - 1)) ? 1'b1:1'b0;
assign v_active = ((v_counter >= VERT_FP + VERT_SYNCP + VERT_BP - 1) && (v_counter < VERT_WHOLE - 1)) ? 1'b1:1'b0;
assign video_valid = h_active & v_active;

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