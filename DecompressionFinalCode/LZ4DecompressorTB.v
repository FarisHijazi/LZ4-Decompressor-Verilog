`timescale 1ns / 1ps
module LZ4DecompressorTB ();
	parameter word_size = 8;
	// parameter address_size = 16;


	// Compressed data =	10 31 0100	10 32 0100	10 33 0100 	00 0e00		10 31 0e00		10 32 0e00		02 0f00		03 0200			50 31 3131 3131 00 00 
	// Compressed input:	16 49 1 0	16 50 1 0	16 51 1 0	0 14 0		16 49 14 0		16 50 14 0		2 15 0		3 2 0 			80 49 49 49 49 49 0 0
	// Compressed Decimal =	11111 		22222		33333		1111		12222			23333			311111		1111111 		11111

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
		compressed_word = 16;
		@(negedge clk) // Read_Done_3
		compressed_word = 49;
		@(negedge clk)
		compressed_word = 1;
		@(negedge clk)
		compressed_word = 0;
		@(negedge clk)

		compressed_word = 16;
		@(negedge clk)
		compressed_word = 50;
		@(negedge clk)
		compressed_word = 1;
		@(negedge clk)
		compressed_word = 0;
		@(negedge clk)


		compressed_word = 16;
		@(negedge clk)
		compressed_word = 51;
		@(negedge clk)
		compressed_word = 1;
		@(negedge clk)
		compressed_word = 0;
		@(negedge clk)




		compressed_word = 0;
		@(negedge clk)
		compressed_word = 14;
		@(negedge clk)
		compressed_word = 0;
		@(negedge clk)


		compressed_word = 16;
		@(negedge clk)
		compressed_word = 49;
		@(negedge clk)
		compressed_word = 14;
		@(negedge clk)
		compressed_word = 0;
		@(negedge clk)


		// 10 32 0e00
		// 23333		
		// 16 50 14 0
		compressed_word = 16;
		@(negedge clk)
		compressed_word = 50;
		@(negedge clk)
		compressed_word = 14;
		@(negedge clk)
		compressed_word = 0;
		@(negedge clk)

		// 02 0f00
		// 311111	
		// 2 15 0	
		compressed_word = 02;
		@(negedge clk)
		compressed_word = 15;
		@(negedge clk)
		compressed_word = 0;
		@(negedge clk)



		// 03 0200
		// 1111111
		// 3 2 0 
		
		compressed_word = 03;
		@(negedge clk)
		compressed_word = 02;
		@(negedge clk)
		compressed_word = 00;
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

		compressed_word = 00;
		@(negedge clk)

		compressed_word = 00;
		
	end
endmodule