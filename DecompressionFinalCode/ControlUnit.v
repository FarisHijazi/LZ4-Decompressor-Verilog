`timescale 1ns / 1ps
module ControlUnit #(parameter word_size = 8) (
		output  [word_size-1:0] uncompressed_word,
		output reg read_byte, // for the input_buffer
		output data_valid, // indicates if uncompressed_word is valid
		input [word_size-1:0] data, // a compressed word coming from the input buffer
		input clk,
		input data_exists, // signal from the input buffer indicating if the data is valid
		input reset // active high
	);

	parameter S_idle =			4'b0000; // 0
	parameter S_ReadDone_1 =	4'b0001; // 2
	parameter S_ReadDone_2 =	4'b0010; // 3
	parameter S_ReadDone_3 =	4'b0011; // 4
	parameter S_Read_5 =		4'b0100; // 5
	parameter S_ReadDone_5 =	4'b0101; // 6
	parameter S_Done =			4'b0110; // 7
	parameter S_Read_6 =		4'b0111; // 8
	parameter S_ReadDone_6 =	4'b1000; // 9
	parameter S_PrepareToCopy =	4'b1001; // a
	parameter S_CopyMatches =	4'b1010; // c

	parameter address_size = 16;

	
	reg [3:0] next_state, current_state;
	

	reg [address_size-1:0] MP, WP;
	reg [address_size-1:0] LL, ML;
	reg outputBuffer_write;
	reg copy;

	// offset reg
	reg [15:0] offset;

	wire [word_size-1:0] outputBuffer_data_in;
	wire [word_size-1:0] outputBuffer_data_out;


	reg incrWP;
	reg incrMP;
	reg loadOffsetHigh; 
	reg loadOffsetLow; 
	reg decrLL; 
	reg loadLL, loadML;  
	reg incrML;
	reg add4ML; 
	reg computeMP;
	reg decrML; 
	reg incrLL;
	assign uncompressed_word = outputBuffer_data_in;
	assign data_valid = outputBuffer_write;

	// output_buffer
	assign outputBuffer_data_in = copy? outputBuffer_data_out: data;

	output_buffer #(.word_size(word_size), .address_size(address_size)) output_buffer(
		.data_out(outputBuffer_data_out),
		.data_in(outputBuffer_data_in), 
		.address_r(MP),
		.address_w(WP),
		.clk(clk),
		.write(outputBuffer_write)
	);

	always @(posedge clk, posedge reset) begin
		if (reset) begin
			current_state = S_idle;
			ML = 0;
			LL = 0;
			WP = 0;
			MP = 0;
			incrWP = 0;
			incrMP = 0;
			offset = 0;

			copy = 0;
			decrLL = 0;
			loadOffsetLow= 0;
			loadOffsetHigh= 0;
			loadLL= 0;
			loadML= 0;
			incrLL= 0;
			incrML= 0;
			add4ML= 0;
			computeMP= 0;
			decrML= 0;
		end
		else begin
			current_state = next_state;
		end

		if(incrMP) begin
			MP = MP + 1;
		end
		if(incrWP) begin
			WP = WP + 1;
		end
		if (decrLL) begin
			LL = LL - 1;
		end 
		if (loadOffsetLow) begin
			offset[7:0] = data; 
		end 
		if (loadOffsetHigh) begin
			offset[15:8] = data; 
		end 
		if (loadLL) begin
			LL = data[word_size-1:4];
		end 
		if (loadML) begin
			ML = data[3:0];
		end
		if (incrLL) begin
			LL = LL + data;
		end 
		if (incrML) begin
			ML = ML + data;
		end 
		if (add4ML) begin
			ML = ML + 4;
		end 
		if (computeMP) begin
			MP = WP - offset; 
		end 
		if (decrML) begin
			ML = ML - 1;
		end 

	end


	always @(*) begin
		read_byte = 0;
		outputBuffer_write = 0;
		copy = 0;
		decrLL = 0;
		loadOffsetLow= 0;
		loadOffsetHigh= 0;
		loadLL= 0;
		loadML= 0;
		incrLL= 0;
		incrML= 0;
		add4ML= 0;
		computeMP= 0;
		decrML= 0;
		incrWP = 0;
		incrMP = 0;

		case (current_state)
			S_idle:
				if (data_exists)begin 	
					read_byte = 1;
					next_state = S_ReadDone_1;
				end
				else
					next_state = S_idle;

			S_ReadDone_1: begin

				loadML = 1;
				loadLL = 1;
				read_byte = 1;
				if (data[word_size-1:4] == 15) begin// if the LL is 15
					next_state = S_ReadDone_2;
				end
				else begin
					next_state = S_ReadDone_3;
				end
			end
			S_ReadDone_2: begin
				read_byte = 1;
				incrLL = 1; 
				if (data == 255) begin
					next_state = S_ReadDone_2; // loop (go to same state)
				end
				else begin
					next_state= S_ReadDone_3;
				end
			end

			S_ReadDone_3: begin// Read Byte
				read_byte = 1;

				if (LL == 0) begin
					next_state = S_Read_5;
					loadOffsetLow = 1; 
				end 
				else begin// Loop and Write in buffer
					outputBuffer_write = 1;
					decrLL = 1;
					incrWP = 1;
					incrMP = 1;

					next_state = S_ReadDone_3;
				end 
			end 

			S_Read_5: begin// Read Byte
				loadOffsetHigh = 1;
				next_state = S_ReadDone_5;
			end 

			S_ReadDone_5: begin
				computeMP = 1;
				if (offset == 0 && ML == 0)
					next_state = S_Done;
				else if (ML == 15)
					next_state = S_Read_6;
				else
					next_state = S_PrepareToCopy;
			end

			S_Done: begin
			end

			S_Read_6: begin
				read_byte = 1;
				next_state = S_ReadDone_6;
			end
			
			S_ReadDone_6: begin
				incrML = 1; 
				
				if (data == 255) begin
					next_state = S_Read_6;
				end 
				else begin
					next_state = S_PrepareToCopy;
				end
			end
			
			S_PrepareToCopy: begin
				add4ML = 1; 
				incrMP = 1; 
				copy = 1; 
				next_state = S_CopyMatches;
			end

			S_CopyMatches:
				if (ML == 0) begin
					next_state = S_idle;
				end
				else begin
					outputBuffer_write = 1;
					copy = 1;
					incrWP = 1;
					incrMP = 1;
					decrML = 1;
					next_state = S_CopyMatches;
				end
			default:
				next_state = S_idle;
		endcase
	end
endmodule
