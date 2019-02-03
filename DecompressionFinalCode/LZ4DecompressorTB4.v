`timescale 1ns / 1ps



module LZ4DecompressorTB4 ();
	parameter word_size = 8;
	// parameter address_size = 16;

	// 0123456789abcdefg 00
	// Compressed data =	f0	02	3031	3233	3435	3637	3839	6162	6364	6566	67	00
	// Decompressed data = 	0123456789abcdefg
	// decimal input:		240	 2	4849	5051	5253	5455	5657	9798	99100	101102	103	00	

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

		// f0	02	0123456789abcdefg 00
		compressed_word = 240;
		@(negedge clk) // Read_Done_3
		compressed_word = 2;
		@(negedge clk)
		compressed_word = 48;
		@(negedge clk)
		compressed_word = 49;
		@(negedge clk)

		compressed_word = 50;
		@(negedge clk)
		compressed_word = 51;
		@(negedge clk)
		compressed_word = 52;
		@(negedge clk)
		compressed_word = 53;
		@(negedge clk)
		compressed_word = 54;
		@(negedge clk)
		compressed_word = 55;
		@(negedge clk)
		compressed_word = 56;
		@(negedge clk)
		compressed_word = 57;
		@(negedge clk)



		compressed_word = 97; //a
		@(negedge clk)
		compressed_word = 98;
		@(negedge clk)
		compressed_word = 99;
		@(negedge clk)
		compressed_word = 100;
		@(negedge clk)
		compressed_word = 101;
		@(negedge clk)
		compressed_word = 102;
		@(negedge clk)
		compressed_word = 103;
		@(negedge clk)
		compressed_word = 104;
		@(negedge clk)
		compressed_word = 105;
	end
endmodule