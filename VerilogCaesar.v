//NOTE THIS ISN'T THE ACTUAL IMPLEMENATION, THIS IS JUST CODE COPIED FROM THE ASSIGNMENT

// uses a 1-digit bcd counter enabled at 1Hz
module part4 (CLOCK_50, HEX0);
	input CLOCK_50;
	output [0:6] HEX0;

	wire [3:0] bcd;
	parameter m = 25;
	reg [m-1:0] slow_count;

	reg[3:0] digit_flipper;

	// Create a 1Hz 4-bit counter

	// A large counter to produce a 1 second (approx) enable from the 50 MHz Clock
	always @(posedge CLOCK_50)
		slow_count <= slow_count + 1'b1;

	// four-bit counter that uses a slow enable for selecting digit
	always @ (posedge CLOCK_50)
		if (slow_count == 0)
			if (digit_flipper == 4'h9)
				digit_flipper <= 4'h0;
	 		else
				digit_flipper <= digit_flipper + 1'b1;
				
	assign bcd = digit_flipper;
	// drive the display through a 7-seg decoder
	bcd7seg digit_0 (bcd, HEX0);
	
endmodule
