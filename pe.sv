//pe
`include "utils.pkg"

module pe 
#(
	parameter int ID_VAL = 0,
	parameter int ID_WIDTH = 6,
	parameter int IN_DATA_WIDTH = 8,
	parameter int OUT_DATA_WIDTH = 24
) 
(
	//clk & rest
	input logic clk,
	input logic rst,
	//load ports
	input logic i_load_vld,
	input logic [ID_WIDTH-1:0] i_load_id,
	input logic [IN_DATA_WIDTH-1:0] i_load_data,
	output logic o_load_vld,
	output logic [ID_WIDTH-1:0] o_load_id,
	output logic [IN_DATA_WIDTH-1:0] o_load_data,
	input logic i_pop_vld,
	output logic o_pop_vld,
	//data ports
	input logic [OUT_DATA_WIDTH-1:0] i_up_data,
	input logic [IN_DATA_WIDTH-1:0] i_left_data,
	output logic [IN_DATA_WIDTH-1:0] o_right_data,
	output logic [OUT_DATA_WIDTH-1:0] o_down_data
);

localparam UP2DN_PN = 3;
localparam LF2RT_PN = 1;

assign hit_id = in_load_vld && i_load_id == ID_VAL;

always_ff @(posedge clk) begin
	if(rst == 1)
		load_index <= 0;
	else if(hit_id == 1)
		load_index <= load_index + 1;
end

always_ff @(posedge clk) begin
	if(hit_id == 1)
		load_wgt[load_index] <= load_data;
end

always_ff @(posedge clk) begin
	if(hit_id == 1)
		o_load_vld <= 0;
	else
		o_load_vlad <= 1;
	o_load_id <= i_load_id;
	o_load_data <= o_load_data;
end

always_ff @(posedge clk) begin
	if(rst == 1)
		pop_index <= 0;
	else if(i_pop_vld == 1)
		pop_index <= pop_index + 1;
end

assign pop_vld_s[0] = i_pop_vld;

generate 
	for(int i = 0; i < UP2DN_PN; i++) begin
		always_ff @(posedge clk) begin
			pop_vld_s[i+1] <= pop_vld_s[i];
		end
	end
endgenerate

assign o_pop_vld = pop_vld_s[UP2DN_PN];

always_ff @(posedge clk) begin
	up_data_r0 <= i_up_data;
	left_data_r0 <= i_left_data;
end

always_ff @(posedge clk) begin
	down_data_r0 <= left_data_r0 * load_wgt[pop_index] + up_data_r0;
	o_down_data <= down_data_r0;
end

assign right_data_s[0] = i_left_data;

generate
	for(int i = 0; i < LF2RT_PN; i++) begin
		right_data_s[i+1] <= right_data_s[i];
	end
endgenerate

assign o_right_data = right_data_s[LF2RT_PN-1];

endmodule

	

