//systolic_pe_array
`include "utls_pkg.sv"

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

logic stc_load_vld[0:PE_ARRAY_W-1][0:PE_ARRAY_H];
logic [$clog2(PE_ARRAY_H)-1:0] stc_load_id[0:PE_ARRAY_W-1][0:PE_ARRAY_H];
logic [IN_DATA_WIDTH-1:0] stc_load_data[0:PE_ARRAY_W-1][0:PE_ARRAY_H];
logic stc_pop_vld[0:PE_ARRAY_W-1][0:PE_ARRAY_H];
logic [OUT_DATA_WIDTH-1:0] stc_up_data[0:PE_ARRAY_W-1][0:PE_ARRAY_H];
logic [IN_DATA_WIDTH-1:0] stc_left_data[0:PE_ARRAY_W][0:PE_ARRAY_H-1];


generate 
	for(int i = 0; i < PE_ARRAY_W; i++) begin
		assign stc_load_vld[i][0] = i_load_vld[i];
		assign stc_load_id[i][0] = i_load_id[i];
		assign stc_load_data[i][0] = i_load_data[i];
		assign stc_pop_vld[i][0] = i_pop_vld[i];
		assign stc_up_data[i][0] = i_up_data[i];
	end
	
	for(int i = 0; i < PE_ARRAY_H; i++) begin
		assign stc_left_data[0][i] = i_left_data[i];
	end

	for(int j = 0; j < PE_ARRAY_W; j++) begin
		for(int i = 0; i < PE_ARRAY_H; i++) begin
			pe #(.ID_VAL(i), .ID_WIDTH($clog2(PE_ARRAY_H)), .IN_DATA_WIDTH(IN_DATA_WIDTH), .OUT_DATA_WIDTH(OUT_DATA_WIDTH))
			(
				.clk(clk),
				.rst(rst),
				.i_load_vld(stc_load_vld[j][i]),
				.i_load_id(stc_load_id[j][i]),
				.i_load_data(stc_load_data[j][i]),
				.o_load_vld(stc_load_vld[j][i+1]),
				.o_load_id(stc_load_id[j][i+1]),
				.o_load_data(stc_load_data[j][i+1]),
				.i_pop_vld(stc_pop_vld[j][i]),
				.o_pop_vld(stc_pop_vld[j][i+1]),
				.i_up_data(stc_up_data[j][i]),
				.i_left_data(stc_left_data[j][i]),
				.o_down_data(stc_up_data[j][i+1]),
				.o_right_data(stc_left_data[j+1][i])
			);
		end
	end

	for(int i = 0; i < PE_ARRAY_W; i++) begin
		o_down_data[i] = stc_up_data[PE_ARRAY_H][i];
	end

endgenerate




