module shiftreg(en, in, clk, q);
	parameter n = 4;
	input en;
	input in;
	input clk;
	output [n-1:0] q;
	reg [n-1:0] q;
	
	initial
		q = 4'd10;
		always @(posedge clk)
			begin
				if(en)
				q = {in, q[n-1:1]};
			end
endmodule

module shiftregtest;

	parameter n = 4;
	reg en, in, clk;
	wire [n-1: 0] q;
	//reg[n-1:0] q;
	
	shiftreg shreg(en, in, clk, q);
	
	initial begin
		clk=0;
	end
	
	always
		#2 clk=~clk;
		initial
			$monitor($time, " EN=%b, in=%b, Q=%b\n", en, in, q);
			initial begin
				in=0; en=0;
				#4 in=1; en=1;
				#4 in=1; en=0;
				#4 in=0; en=1;
				#5 $finish;
			end
endmodule