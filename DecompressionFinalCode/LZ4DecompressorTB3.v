`timescale 1ns / 1ps



module LZ4DecompressorTB3 ();
	parameter word_size = 8;
	// parameter address_size = 16;


	// Compressed data =	1f 31 0100 01 								50	3131 3131 31
	// Decompressed data = 	1	11111	11111	11111	11111		 	11111
	// decimal input:		31	49	1	0	1							80	49	49	49	49	49	0	0

	// 11111 22222 33333 1111 12222 23333 311111 1111111 11111

	reg clk, reset, data_exists;
	reg [word_size-1:0] compressed_word;
	reg write_en;
	wire [word_size-1:0] uncompressed_word;
	wire data_valid;

	LZ4Decompressor #(.word_size(word_size))  decompressor(
		.uncompressed_word(uncompressed_word),	// 
		.data_valid(data_valid),
		.compressed_word(compressed_word),
		.write(write_en),
		.clk(clk),
		.reset(reset)
	);

	initial begin
		clk = 0 ; forever #10 clk = ~clk ;
	end

	initial begin
		reset = 1;
		@(negedge clk)
		reset = 0;
		@(negedge clk) // readbyte s1
		write_en = 1;
		compressed_word = 31;
		@(negedge clk) // Read_Done_3
		compressed_word = 49;
		@(negedge clk)
		compressed_word = 1;
		@(negedge clk)
		compressed_word = 0;
		@(negedge clk)

		compressed_word = 1;
		@(negedge clk)
		compressed_word = 80;
		@(negedge clk)
		compressed_word = 49;
		@(negedge clk)
		compressed_word = 49;
		@(negedge clk)


		compressed_word = 49;
		@(negedge clk)
		compressed_word = 49;
		@(negedge clk)
		compressed_word = 49;
		@(negedge clk)
		compressed_word = 0;
		@(negedge clk)



		compressed_word = 0;
		
	end
endmodule