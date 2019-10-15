module controller(ns, PCWrite, PCWriteCond, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource1, PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0, ALUSrcA, RegWrite, RegDst, cs, op);
	input [3:0] cs;
	input [5:0] op;
	output [3:0] ns;
	output PCWrite, PCWriteCond, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource1, PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0, ALUSrcA, RegWrite, RegDst; 
	
	wire w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, w16, w17;
	
	assign w1 = (~cs[3] & ~cs[2] & ~cs[1] & ~cs[0]);
	assign w2 = (~cs[3] & ~cs[2] & ~cs[1] & cs[0]);
	assign w3 = (~cs[3] & ~cs[2] & cs[1] & ~cs[0]);
	assign w4 = (~cs[3] & ~cs[2] & cs[1] & cs[0]);
	assign w5 = (~cs[3] & cs[2] & ~cs[1] & ~cs[0]);
	assign w6 = (~cs[3] & cs[2] & ~cs[1] & cs[0]);
	assign w7 = (~cs[3] & cs[2] & cs[1] & ~cs[0]);
	assign w8 = (~cs[3] & cs[2] & cs[1] & cs[0]);
	assign w9 = (cs[3] & ~cs[2] & ~cs[1] & ~cs[0]);
	assign w10 = (cs[3] & ~cs[2] & ~cs[1] & cs[0]);
	assign w11 = (~cs[3] & ~cs[2] & ~cs[1] & cs[0] & ~op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & ~op[0]);
	assign w12 = (~cs[3] & ~cs[2] & ~cs[1] & cs[0] & ~op[5] & ~op[4] & ~op[3] & op[2] & ~op[1] & ~op[0]);
	assign w13 = (~cs[3] & ~cs[2] & ~cs[1] & cs[0] & ~op[5] & ~op[4] & ~op[3] & ~op[2] & ~op[1] & ~op[0]);
	assign w14 = (~cs[3] & ~cs[2] & cs[1] & ~cs[0] & op[5] & ~op[4] & op[3] & ~op[2] & op[1] & op[0]);
	assign w15 = (~cs[3] & ~cs[2] & ~cs[1] & cs[0] & op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & op[0]);
	assign w16 = (~cs[3] & ~cs[2] & ~cs[1] & cs[0] & op[5] & ~op[4] & op[3] & ~op[2] & op[1] & op[0]);
	assign w17 = (~cs[3] & ~cs[2] & cs[1] & ~cs[0] & op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & op[0]);
	
	assign PCWrite = (w1 | w10);
	assign PCWriteCond = (w9);
	assign IorD = (w4 | w6);
	assign MemRead = (w1 | w4);
	assign MemWrite = (w6);
	assign IRWrite = (w1);
	assign MemtoReg = (w5);
	assign PCSource1 = (w10);
	assign PCSource0 = (w9);
	assign ALUOp1 = (w7);
	assign ALUOp0 = (w9);
	assign ALUSrcB1 = (w2 | w3);
	assign ALUSrcB0 = (w1 | w2);
	assign ALUSrcA = (w3 | w7 | w9);
	assign RegWrite = (w5 | w8);
	assign RegDst = (w8);
	
	assign ns[3] = (w11 | w12);
	assign ns[2] = (w4 | w7 | w13 | w14);
	assign ns[1] = (w7 | w13 | w15 | w16 | w17);
	assign ns[0] = (w1 | w7 | w11 | w14 | w17);
	
endmodule

module testbench;

	reg [3:0] cs;
	reg [5:0] op;
	wire [3:0] ns;
	wire PCWrite, PCWriteCond, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource1, PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0, ALUSrcA, RegWrite, RegDst; 
	
	controller control(ns, PCWrite, PCWriteCond, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource1, PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0, ALUSrcA, RegWrite, RegDst, cs, op);
	
	initial begin
		$monitor(, $time, " cs=%b, ns=%b", cs, ns);
		#0 op=6'b101011; cs=4'b0000;
		#5 cs = ns;
		#5 cs = ns;
		#5 cs = ns;
		#5 $finish;
		
	end
	
endmodule