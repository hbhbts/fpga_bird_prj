//pe
`include "utils_pkg.sv"

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

logic hit_id;
logic [1-1:0] load_index;
logic [IN_DATA_WIDTH-1:0] load_wgt[0:1];
logic [IN_DATA_WIDTH-1:0] load_wgt_r0[0:1];
logic [1-1:0] pop_index;
logic pop_vld_s[0:UP2DN_PN];
logic [OUT_DATA_WIDTH-1:0] up_data_r0;
logic [OUT_DATA_WIDTH-1:0] down_data_r0;
logic [IN_DATA_WIDTH-1:0] left_data_r0;
logic [IN_DATA_WIDTH-1:0] left_data_r1;
logic [IN_DATA_WIDTH-1:0] right_data_s[0:LF2RT_PN];




assign hit_id = i_load_vld && i_load_id == ID_VAL;

always_ff @(posedge clk) begin
	if(rst == 1)
		load_index <= 0;
	else if(hit_id == 1)
		load_index <= load_index + 1'd1;
end

always_ff @(posedge clk) begin
	if(hit_id == 1)
		load_wgt[load_index] <= i_load_data;
end

always_ff @(posedge clk) begin
	load_wgt_r0 <= load_wgt;
end

always_ff @(posedge clk) begin
	if(hit_id == 1)
		o_load_vld <= 0;
	else
		o_load_vld <= 1;
	o_load_id <= i_load_id;
	o_load_data <= i_load_data;
end

always_ff @(posedge clk) begin
	if(rst == 1)
		pop_index <= 0;
	else if(i_pop_vld == 1)
		pop_index <= pop_index + 1'd1;
end

assign pop_vld_s[0] = i_pop_vld;

generate 
	for(genvar i = 0; i < UP2DN_PN; i++) begin: gen_pop_vld_s
		always_ff @(posedge clk) begin
			pop_vld_s[i+1] <= pop_vld_s[i];
		end
	end
endgenerate

assign o_pop_vld = pop_vld_s[UP2DN_PN];

always_ff @(posedge clk) begin
	up_data_r0 <= i_up_data;
	left_data_r0 <= i_left_data;
	left_data_r1 <= left_data_r0;
end

always_ff @(posedge clk) begin
	down_data_r0 <= left_data_r1 * load_wgt_r0[pop_index] + up_data_r0;
	o_down_data <= down_data_r0;
end

assign right_data_s[0] = i_left_data;

generate
	for(genvar i = 0; i < LF2RT_PN; i++) begin: gen_right_data_s
		always_ff @(posedge clk) begin
			right_data_s[i+1] <= right_data_s[i];
		end
	end
endgenerate

assign o_right_data = right_data_s[LF2RT_PN];

endmodule

	


