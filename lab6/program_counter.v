module PC(count, clock, reset);
	input clock, reset;
	output [31:0] count;
	reg [31:0] count;
	
	always @(posedge clock)
		if(!reset)
			count = count+1;
		else
			count = 0;
endmodule

module tb_PC;
	reg clock, reset;
	wire [31:0] count;
	
	PC pc(count, clock, reset);
	
	initial begin
		repeat(500)
		#5 clock = ~clock;
	end
	
	initial begin
		$monitor(, $time, " Count=%b, Clock=%b, Reset=%b", count, clock, reset);
		#0 clock = 1'b0; reset = 1'b1;
		#10 reset = 1'b0;
	end
	
endmodule