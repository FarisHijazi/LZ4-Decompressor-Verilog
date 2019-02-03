`timescale 1ns / 1ps

module output_buffer #(parameter word_size=8, address_size=4)(
	output reg [word_size-1:0] data_out,
	input [word_size-1:0] data_in, 
	input [address_size-1:0] address_r, // for reading
	input [address_size-1:0] address_w, // for writing
	input clk, write);

	parameter memory_size=2**address_size;
	
	reg [ word_size-1:0] memory[memory_size-1:0];
	

	always @ (posedge clk) begin
		if (write) memory[address_w] = data_in;
		data_out = memory[address_r];
	end

endmodule
