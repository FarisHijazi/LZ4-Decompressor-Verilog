`timescale 1ns / 1ps

module input_buffer #(parameter word_size=8, address_size=16)(
	output reg [word_size-1:0] data_out,
	output data_exists,	// true when there is data that hasn't been read yet
	input [word_size-1:0] data_in, 
	input read_byte, // outputs the next byte (if valid) and increments the read pointer
	input clk, write // write enable
	);
	
	parameter memory_size=2**address_size; // memory size is computed from the address size
		
	reg [address_size-1:0] read_pointer; // the address of the next word to be read
	reg [address_size-1:0] write_pointer; // 
	reg [word_size-1:0] memory [memory_size-1:0]; // we have as many as memory_size bytes

	reg carry; // signal is never used, this is to avoid compiler warnings
	
	initial begin
		write_pointer = 0;
		read_pointer = 0;
	end
	
	assign data_exists = (read_pointer < write_pointer);

	always @ (posedge clk) begin
		if (write) begin
			memory[write_pointer] = data_in;
			{carry, write_pointer} = write_pointer + 1; // carry is never used
		end
		if (read_byte && data_exists) begin
			data_out = memory[read_pointer];
			read_pointer = read_pointer + 1;
		end
	end

endmodule
