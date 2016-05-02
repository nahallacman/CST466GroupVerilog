
module clkDiv(
			input wire Clk_50MHz, 
			input wire rst,
			output reg Clk_1Hz
			);
			
	reg [25:0] count = 26'b0;
	
	initial begin
	Clk_1Hz = 1'b0;
	end
	
	always @(posedge Clk_50MHz or negedge rst)
	if(!rst)
	begin
		count = 0;
		Clk_1Hz = 1'b0;
	end
	else
	if(count > 25000000)
	begin
		Clk_1Hz = !Clk_1Hz;
		count = 26'b0;
	end
	else
	begin
		count = count + 1;
	end
		
endmodule
