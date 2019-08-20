// Magnitude comparator

module mag_beh(a, b, c);

	input [3:0] a;
	input [3:0] b;
	output [2:0]c;
	//reg c;
	always@(a or b)
		if(a==b) c=3b'100;
		if(a>b)	c=3b'010;
		else	c=3b'001;
		
endmodule

module testbench;
	reg [3:0]a, [3:0]b;
	wire [2:0] c;
	
	mag_com mag_beh(a, b, c);
	initial
		begin
			$monitor(, $time, " a=%4b, b=%4b, c=%3b", a, b, c);
			#0 a=4b'0000; b=4b'0000;
			#5 a=4b'0001; b=4b'0000;
			#10 a=4b'0000; b=4b'0001;
			#100 $finish
		end
		
endmodule