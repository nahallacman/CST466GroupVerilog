//NOTE THIS ISN'T THE ACTUAL IMPLEMENATION, THIS IS JUST CODE COPIED FROM THE ASSIGNMENT

// uses a 1-digit bcd counter enabled at 1Hz
module VerilogCaesar (CLOCK_50, HEX0, HEX1);
	input CLOCK_50;
	output [0:6] HEX0;
	output [0:6] HEX1;

	wire clk_1Hz;
	wire [3:0] bcd, bcd2;
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
	/****************************
		if (digit_flipper == 4'h9)
		begin
			digit_flipper <= 4'h0;
			
			if(digit_flipper2 == 2'b10)
			begin
			
			end
		end
		else
			digit_flipper <= digit_flipper + 1'b1;
	****************************/
	end
				
	assign bcd = digit_flipper;
	assign bcd2 = {2'b0, digit_flipper2};
	
	// drive the display through a 7-seg decoder
	bcd7seg digit_0(
				.bcd(bcd), 
				.display(HEX0)
				);
				
	bcd7seg digit_1(
				.bcd(bcd2), 
				.display(HEX1)
				);
	
endmodule
