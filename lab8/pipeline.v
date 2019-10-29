module Encoder( opcode, funcode);
	input[7:0] funcode;
	output[2:0] opcode;
	reg[2:0] opcode;
	
	always @(funcode) begin
		if (funcode[0])
			opcode = 3'b000;
		else if (funcode[1])
			opcode = 3'b001;
		else if (funcode[2])
			opcode = 3'b010;
		else if (funcode[3])
			opcode = 3'b011;
		else if (funcode[4])
			opcode = 3'b100;
		else if (funcode[5])
			opcode = 3'b101;
		else if (funcode[6])
			opcode = 3'b110;
		else if (funcode[7])
			opcode = 3'b111;
	end
	
endmodule

module ALU(C, X, A, B, opcode);
	input[3:0] A, B;
	input[2:0] opcode;
	output[3:0] X;
	output C;
	
	assign {C, X} = (opcode == 3'b000) ? A + B :
					(opcode == 3'b001) ? A - B :
					(opcode == 3'b010) ? A ^ B :
					(opcode == 3'b011) ? A | B :
					(opcode == 3'b100) ? A & B :
					(opcode == 3'b101) ? ~(A | B) :
					(opcode == 3'b110) ? ~(A & B) : ~(A ^ B);
					
endmodule

module parityGenerator(P, X);
	input[3:0] X;
	output P;
	
	assign P = ~( X[0] ^ X[1] ^ X[2] ^ X[3]);
	
endmodule

module pipeline1(ctrl, Aout, Bout, clock, opcode, A, B);
	input clock;
	input[3:0] A, B;
	input[2:0] opcode;
	output[2:0] ctrl;
	output[3:0] Aout, Bout;
	reg[2:0] ctrl;
	reg[3:0] Aout, Bout;
	
	always @(posedge clock) begin
		Aout <= A;
		Bout <= B;
		ctrl <= opcode;
	end
	
endmodule

module pipeline2(Xout, Xin, clock);
	input clock;
	input[3:0] Xin;
	output[3:0] Xout;
	reg[3:0] Xout;
	
	always @(posedge clock)
		Xout <= Xin;
		
endmodule

module integrate(P, A, B, funcode, clock);
	input[3:0] A, B;
	input[7:0] funcode;
	input clock;
	output P;
	
	wire[2:0] opcode, ctrl;
	wire[3:0] Aout, Bout, Xout, Xin;
	wire C;
	
	Encoder m1(opcode, funcode);
	pipeline1 m2(ctrl, Aout, Bout, clock, opcode, A, B);
	ALU m3(C, Xin, Aout, Bout, ctrl);
	pipeline2 m4(Xout, Xin, clock);
	parityGenerator m5(P, Xout);
	
endmodule

module testbench;
	reg[3:0] A, B;
	reg[7:0] funcode;
	reg clock;
	wire P;
	
	integrate m(P, A, B, funcode, clock);
	
	initial begin
		$monitor($time, " A=%b, B=%b, funcode=%b, opcode=%b, X=%b, P=%b", A, B, funcode, m.opcode, m.Xout, P);
		#2 clock = 1'b0;
		#10 A = 4'b0110; B = 4'b1101; funcode = 8'b00000001;
		#8 funcode = 8'b00000010;
		#8 funcode = 8'b00000100;
		#8 funcode = 8'b00001000;
		#8 funcode = 8'b00010000;
		#8 funcode = 8'b00100000;
		#8 funcode = 8'b01000000;
		#8 funcode = 8'b10000000;
		#10 $finish;
	end
	
	always
		#2 clock = ~clock;
	
endmodule