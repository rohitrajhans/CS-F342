module mux2to1(out, sel, in1, in2);
	input in1, in2, sel;
	output out;
	wire not_sel, a1, a2;
	not (not_sel, sel);
	and (a1, sel, in2);
	and (a2, not_sel, in1);
	or (out, a1, a2);
endmodule

module mux3to1(out, sel1, sel2, in1, in2, in3);
	input in1, in2, in3, sel1, sel2;
	output out;
	wire not_sel1, not_sel2, a1, a2, a3, a4, a5, a6, a7;
	
	not (not_sel1, sel1);
	not (not_sel2, sel2);
	and (a1, not_sel1, not_sel2);
	and (a2, not_sel1, sel2);
	and (a3, sel1, not_sel2);
	
	and (a4, a1, in1);
	and (a5, a3, in2);
	and (a6, a2, in3);
	
	or (a7, a4, a5);
	or (out, a7, a6);
endmodule

module bit8_mux2to1(out, sel, in1, in2);
	input[7:0] in1, in2;
	input sel;
	output[7:0] out;
	genvar j;
	// j is a variable used in the generate block
	
	generate 
		for(j=0; j<8; j=j+1) begin: mux_loop
			// mux_loop is the name of the for loop
			mux2to1 m1(out[j], sel, in1[j], in2[j]);
		end
	endgenerate
	
endmodule

module bit32_mux2to1(out, sel, in1, in2);
	input[31:0] in1, in2;
	input sel;
	output[31:0] out;
	
	genvar j;
	
	generate
		for(j=0; j<32; j=j+8) begin: mux_loop
			bit8_mux2to1 m2(out[j+7:j], sel, in1[j+7:j], in2[j+7:j]);
		end
	endgenerate

endmodule

module bit32_mux3to1(out, sel1, sel2, in1, in2, in3);
	input[31:0] in1, in2, in3;
	input sel1, sel2;
	output [31:0] out;
	
	genvar j;
	
	generate
		for(j=0; j<32; j=j+1) begin: mux_loop
			mux3to1 m3(out[j], sel1, sel2, in1[j], in2[j], in3[j]);
		end
	endgenerate

endmodule

module bit32_AND(out, in1, in2);
	input[31:0] in1, in2;
	output[31:0] out;
	assign {out} = in1 & in2;
endmodule

module bit32_OR(out, in1, in2);
	input[31:0] in1, in2;
	output[31:0] out;
	assign {out} = in1 | in2;
endmodule

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

module ADDER_8(sum, carry, x, y, z);
	input [7:0] x, y;
	input z;
	output carry;
	output [7:0] sum;
	
	wire c[6:0];
	
	FADDER fad0(sum[0], c[0], x[0], y[0], z);
	FADDER fad1(sum[1], c[1], x[1], y[1], c[0]);
	FADDER fad2(sum[2], c[2], x[2], y[2], c[1]);
	FADDER fad3(sum[3], c[3], x[3], y[3], c[2]);
	FADDER fad4(sum[4], c[4], x[4], y[4], c[3]);
	FADDER fad5(sum[5], c[5], x[5], y[5], c[4]);
	FADDER fad6(sum[6], c[6], x[6], y[6], c[5]);
	FADDER fad7(sum[7], carry, x[7], y[7], c[6]);
endmodule

module ADDER_32(sum, carry, x, y, z);
	input[31:0] x, y;
	input z;
	output carry;
	output[31:0] sum;
	
	wire c[2:0];
	
	ADDER_8 add0(sum[7:0], c[0], x[7:0], y[7:0], z);
	ADDER_8 add1(sum[15:8], c[1], x[15:8], y[15:8], c[0]);
	ADDER_8 add2(sum[23:16], c[2], x[23:16], y[23:16], c[1]);
	ADDER_8 add3(sum[31:24], carry, x[31:24], y[31:24], c[2]);
	
endmodule

// module tb_8bit2to1mux;
	// reg [31:0] in1, in2, in3;
	// reg sel1, sel2;
	// wire [31:0] out;
	
	// bit32_mux3to1 m1(out, sel1, sel2, in1, in2, in3);
	
	// initial begin
		// $monitor(, $time, " INP 1 = %b, INP 2 = %b, INP 3 = %b, SEL 1 = %b, SEL 2 = %b, OUT = %b", in1, in2, in3, sel1, sel2, out);
		// in1 = 32'b10101010101010101010101010101010;
		// in2 = 32'b01010101010101010101010101010101;
		// in3 = 32'b11110000111100001111000011110000;
		// sel1 = 1'b0;
		// sel2 = 1'b0;
		// #100 sel1 = 1'b1; sel2 = 1'b0;
		// #200 sel1 = 1'b0; sel2 = 1'b1;
		// #1000 $finish;
	// end
	
// endmodule

module bit32_NOT(a, b);
	input[31:0] b;
	output[31:0] a;
	
	assign {a} = ~b;
endmodule

module ALU(a, b, binvert, cin, operation, result, cout);
	input[31:0] a, b;
	input binvert, cin;
	input[1:0] operation;
	output[31:0] result;
	output cout;
	wire[31:0] neg_b, fa_ip2, out0, out1, out2;
	
	bit32_NOT m0(neg_b, b);
	bit32_mux2to1 m1(fa_ip2, binvert, b, neg_b);
	ADDER_32 m2(out2, cout, a, fa_ip2, cin);
	bit32_AND m3(out0, a, b);
	bit32_OR m4(out1, a, b);
	
	bit32_mux3to1 m5(result, operation[0], operation[1], out0, out1, out2);
endmodule
	

module tbALU;
	reg binvert, cin;
	reg[1:0] operation;
	reg[31:0] a, b;
	wire [31:0] result;
	wire cout;
	
	ALU m0(a, b, binvert, cin, operation, result, cout);
	
	initial begin
		$monitor (, $time, " a=%b, b=%b, operation=%b, result=%b, carry=%b", a, b, operation, result, cout);
		a = 32'ha5a5a5a5;
		b = 32'h5a5a5a5a;
		operation = 2'b00;
		binvert = 1'b0;
		cin = 1'b0;
		#100 operation = 2'b01;
		#100 operation = 2'b10;
		#100 binvert = 1'b1;
		#200 $finish;
	end
	
endmodule