`timescale 1ns / 1ps
module LZ4Decompressor #(parameter word_size=8)(
		output [word_size-1:0] uncompressed_word,	// 
		output data_valid,
		input [word_size-1:0] compressed_word,
		input write, clk, reset
	);
	
	wire [word_size-1:0] data;
	wire read_word;

	input_buffer #(.word_size(word_size), .address_size(16)) input_buffer (
		.data_out(data),
		.data_exists(data_exists),// true when there is data that hasn't been read yet
		.data_in(compressed_word), 
		.read_byte(read_word), // outputs the next byte (if valid) and increments the read pointer
		.clk(clk),
		.write(write)
	);
		
	ControlUnit #(.word_size(word_size)) ControlUnit(
		.uncompressed_word(uncompressed_word),
		.read_byte(read_word),
		.data_valid(data_valid),
		.data(data),
		.clk(clk),
		.data_exists(data_exists),
		.reset(reset)
	);
endmodule