//NOTE THIS ISN'T THE ACTUAL IMPLEMENATION, THIS IS JUST CODE COPIED FROM THE ASSIGNMENT

// uses a 1-digit bcd counter enabled at 1Hz
module VerilogCaesar (CLOCK_50, SW, ENCRYPT, HEX0, HEX1, HEX2, HEX3);
	input CLOCK_50;
	input ENCRYPT;
	input [0:4]SW;
	output [0:6] HEX0;
	output [0:6] HEX1;
	output [0:6] HEX2;
	output [0:6] HEX3;

	wire clk_1Hz;
	wire [3:0] bcd, bcd2, bcd3, bcd4;
	wire [1:0] hundredsFiller;
	reg[3:0] digit_flipper;
	reg[1:0] digit_flipper2;
	
	initial begin
	digit_flipper = 4'b0;
	digit_flipper2 = 2'b0;
	end

	// Create a 1Hz clock
	clkDiv c0(
			.Clk_50MHz(CLOCK_50),
			.rst(1'b1),
			.Clk_1Hz(clk_1Hz)
			);

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
				
	assign bcd = digit_flipper;
	assign bcd2 = {2'b0, digit_flipper2};
	
	binary_to_BCD bcd0(
					.A(SW),
					.ONES(bcd3),
					.TENS(bcd4),
					.HUNDREDS(hundredsFiller)
					);
	
	// drive the display through a 7-seg decoder
	bcd7seg digit_0(
				.bcd(bcd), 
				.display(HEX0)
				);
				
	bcd7seg digit_1(
				.bcd(bcd2), 
				.display(HEX1)
				);
				
	bcd7seg digit_2(
				.bcd(bcd3), 
				.display(HEX2)
				);
				
	bcd7seg digit_3(
				.bcd(bcd4), 
				.display(HEX3)
				);
	
endmodule
