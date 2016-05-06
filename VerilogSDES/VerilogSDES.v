/* Comments for assignment:
* Using 6 switches. 
* 		Rightmost is the encrypt/decrypt selection.
*		Next 5 switches from the right are the key 
*			Rightmost switch is LSB, leftmost is MSB
* Using 3 pairs of 7 seg displays.
*		Left most pair on the board is pair 0, right most is pair 2 (opposite order direction from switches!)
*			Pair 0 is the key, can never be greater than 25
				Pair 0 is Hex 4 and Hex 5
*			Pair 1 is the plaintext when encrypting, and is the cyhpertext when decrypting
				Pair 1 is Hex 2 and Hex 3
*			Pair 2 is cyphertext when encrypting, and is the plaintext when decrypting
				Pair 2 is Hex 0 and Hex 1
*		Pair 1 and pair 2 count up by 1 every second (probably only needs to increase one of the two values at a time? or do we increase both values at the same time?)
*/


// uses a 1-digit bcd counter enabled at 1Hz
module VerilogSDES (CLOCK_50, SW, DECRYPT, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input CLOCK_50;
	input DECRYPT;
	input [0:9]SW;
	output [0:6] HEX0;
	output [0:6] HEX1;
	output [0:6] HEX2;
	output [0:6] HEX3;
	output [0:6] HEX4;
	output [0:6] HEX5;

	wire clk_1Hz;
	wire [3:0] bcd0, bcd1, bcd2, bcd3, bcd4, bcd5;
	wire [1:0] hundredsFiller;
	wire [5:0] encryptOutput;
	wire [5:0] decryptOutput;
	
	wire [5:0] pairOut;
	//wire [5:0] pair2Out;
	//wire [5:0] digit_total;
	
	wire [7:0] K1;
	wire [7:0] K2;
	
	//wires for connecting the key generation pieces together
	wire [9:0] p10_1_out;
	wire [9:0] rotL1_1_out;
	wire [9:0] rotL2_1_out;
	
	reg [0:9] SW_Round;
	
	//reg[3:0] digit_flipper;
	//reg[1:0] digit_flipper2;
	//reg[5:0] digit_total;
	reg[5:0] digit_flipper_ext;
	
	//initial begin
	//digit_flipper = 4'b0;
	//digit_flipper2 = 2'b0;
	//end

	// Create a 1Hz clock
	clkDiv c0(
			.Clk_50MHz(CLOCK_50),
			.rst(1'b1),
			.Clk_1Hz(clk_1Hz)
			);

			/*
	// bcd counters for plain text
	always @ (posedge clk_1Hz)
	begin
		casex({digit_flipper, digit_flipper2})
			6'b1001xx: //we are at x9
			begin
				digit_flipper = 4'b0;
				digit_flipper2 = digit_flipper2 + 1;
			end
			6'b010110:	//we are at 25
			begin
				digit_flipper = 4'b0;
				digit_flipper2 = 2'b0;
			end
			default: 
			begin
				digit_flipper = digit_flipper + 1;
			end
		endcase
	end
	*/
	
	always @ (SW)
	begin
		if (SW > 24)
			SW_Round = 6'd25;
		else
			SW_Round = SW;
	end
	
	// decimal counters that will eventually be converted to bcd
	always @ (posedge clk_1Hz)
	begin
		casex(digit_flipper_ext)
		6'd25:
			begin
			digit_flipper_ext = 6'b000000;
			end
		default:
			begin
			digit_flipper_ext = digit_flipper_ext + 1;
			end
		endcase
	end
	
				
	//assign bcd = digit_flipper;
	//assign bcd2 = {2'b0, digit_flipper2};
	
	//assign digit_total = 6'b000000;
	
	//mux outputs to the correct side on the encrypt switch
	assign pairOut[5:0] = (DECRYPT) ? encryptOutput[5:0] : decryptOutput[5:0]  ;
	//assign pair2Out = (ENCRYPT) ? encryptOutput : decryptOutput ;
	
	
	binary_to_BCD bin_to_bcd0(
					.A(SW_Round),
					.ONES(bcd4),
					.TENS(bcd5),
					.HUNDREDS(hundredsFiller)
					);
	
	binary_to_BCD bin_to_bcd1(
					.A(digit_flipper_ext),
					.ONES(bcd2),
					.TENS(bcd3),
					.HUNDREDS(hundredsFiller)
					);
					
	binary_to_BCD bin_to_bcd2(
					.A(pairOut),
					.ONES(bcd0),
					.TENS(bcd1),
					.HUNDREDS(hundredsFiller)
					);
	
	// drive the display through a 7-seg decoder
	bcd7seg digit_0(
				.bcd(bcd0), 
				.display(HEX0)
				);
				
	bcd7seg digit_1(
				.bcd(bcd1), 
				.display(HEX1)
				);
				
	bcd7seg digit_2(
				.bcd(bcd2), 
				.display(HEX2)
				);
				
	bcd7seg digit_3(
				.bcd(bcd3), 
				.display(HEX3)
				);
				
	bcd7seg digit_4(
				.bcd(bcd4), 
				.display(HEX4)
				);
				
	bcd7seg digit_5(
				.bcd(bcd5), 
				.display(HEX5)
				);
				
	P10 p10_01(
		.in(SW_Round),
		.out(p10_1_out)
	);
				
	RotL1 rotL1_01(
		.in(p10_1_out),
		.out(rotL1_1_out)	
	);
	
	P8 p8_01(
		.in(rotL1_1_out),
		.out(K1)		
	);
	
	RotL2 rotL2_01(
		.in(rotL1_1_out),
		.out(rotL2_1_out)		
	);
	
	P8 p8_02(
		.in(rotL2_1_out),
		.out(K2)		
	);
	
/*	
	SDESEncrypt encrypt_module( // todo: UPDATE THESE INPUTS AND OUTPUTS
				.plaintext(digit_flipper_ext), 
				.key(SW_Round), 
				.cyphertext(encryptOutput)
	);
	*/
	SDESEncrypt encrypt_module( // todo: UPDATE THESE INPUTS AND OUTPUTS
				.plaintext(digit_flipper_ext), 
				.k1(K1),
				.k2(K2),
				.cyphertext(encryptOutput)
	);
	
	SDESDecrypt decrypt_module( // todo: UPDATE THESE INPUTS AND OUTPUTS
				.cyphertext(digit_flipper_ext), 
				.k1(K1),
				.k2(K2),
				.plaintext(decryptOutput)
	);
	
endmodule
