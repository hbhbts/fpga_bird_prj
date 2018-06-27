//systolic_pe_array
module systolic_pe_array 
#(
	parameter int PE_ARRAY_W = 64;
	parameter int PE_ARRAY_H = 64;
	parameter int IN_DATA_WIDTH = 8;
	parameter int OUT_DATA_WIDTH = 24;
)
(
	input logic clk,
	input logic rst,
	input logic i_load_vld[0:PE_ARRAY_W-1],
	input logic [$clog2(PE_ARRAY_H)-1:0] i_load_id[0:PE_ARRAY_W-1],
	input logic [IN_DATA_WIDTH-1:0] i_load_data[0:PE_ARRAY_W-1],
	input logic [IN_DATA_WIDTH-1:0] i_up_data[0:PE_ARRAY_W-1],
	input logic [IN_DATA_WIDTH-1:0] i_left_data[0:PE_ARRAY_H-1],
	output logic [OUT_DATA_WIDTH-1:0] o_down_data[0:PE_ARRAY_W-1]
);






