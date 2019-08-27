module DECODER(d, x, y, z);
	input x, y, z;
	output [7:0] d;
	wire x0, y0, z0;
	
	not n1(x0, x);
	not n2(y0, y);
	not n3(z0, z);
	
	and a1(d[0], x0, y0, z0);
	and a2(d[1], x0, y0, z);
	and a3(d[2], x0, y, z0);
	and a4(d[3], x0, y, z);
	and a5(d[4], x, y0, z0);
	and a6(d[5], x, y0, z);
	and a7(d[6], x, y, z0);
	and a8(d[7], x, y, z);
	
endmodule

module FADDER(s, c, x, y, z);
	input x, y, z;
	output s, c;
	
	wire [7:0] d;
	DECODER dec(d, x, y, z);
	
	assign s = d[1] | d[2] | d[4] | d[7];
	assign c = d[3] | d[5] | d[6] | d[7];
endmodule

module ADDER_8( sum, carry, x, y);
	input [7:0] x, y;
	output carry;
	output [7:0] sum;
	
	wire c[6:0];
	
	FADDER fad0(sum[0], c[0], x[0], y[0], 0);
	FADDER fad1(sum[1], c[1], x[1], y[1], c[0]);
	FADDER fad2(sum[2], c[2], x[2], y[2], c[1]);
	FADDER fad3(sum[3], c[3], x[3], y[3], c[2]);
	FADDER fad4(sum[4], c[4], x[4], y[4], c[3]);
	FADDER fad5(sum[5], c[5], x[5], y[5], c[4]);
	FADDER fad6(sum[6], c[6], x[6], y[6], c[5]);
	FADDER fad7(sum[7], carry, x[7], y[7], c[6]);
endmodule

module testbench;
	reg [7:0] x, y, z;
	wire [7:0] s;
	wire c;
	ADDER_8 add(s, c, x, y);
	initial
		$monitor(, $time, " : x=%8b, y=%8b, s=%8b, c=%b", x, y, s, c);
	initial
		begin
			x=8'b00011001; y=8'b01001011';
		end
endmodule