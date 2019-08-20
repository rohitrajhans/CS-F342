`timescale 1ns / 1ps

module some_logic_component (c,a,b);

	output c;
	input a, b;
	
	wired d;
	
	and a1(d, a, b); // d is output, a and b are inputs
	not n1(c, d);	// c is output, d is input
	
	endmodule