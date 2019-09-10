module ANDarray (regDst, ALUSrc, memToReg, regWrite, memRead, memWrite, branch, ALUOp1, ALUOp2, op);
	input[5:0] op;
	output regDst, ALUSrc, memToReg, regWrite, memRead, memWrite, branch, ALUOp1, ALUOp2;
	
	wire Rformat, lw, sw, beq;
	
	assign Rformat = (~op[0]) & (~op[1]) & (~op[2]) & (~op[3]) (~op[4]) & (~op[5]);
	assign lw = (op[0]) & (op[1]) & (~op[2]) & (~op[3]) (~op[4]) & (op[5]);
	assign sw = (op[0]) & (op[1]) & (~op[2]) & (op[3]) (~op[4]) & (op[5]);
	assign beq = (~op[0]) & (~op[1]) & (op[2]) & (~op[3]) (~op[4]) & (~op[5]);
	
	assign regDst = Rformat;
	assign ALUSrc = lw | sw;
	assign memToReg =  lw;
	assign regWrite = Rformat | lw;
	assign memRead = lw;
	assign memWrite = sw;
	assign branch = beq;
	assign ALUOp1 = Rformat;
	assign ALUOp2 = beq;
	
endmodule

module ALUControl(operation, ALUOp, ff);
	input[1:0] ALUOp;
	reg[5:0] ff;
	output [2:0] operation;
	
	wire w0, w1, w2, w3;
	
	assign w0 = ff[0] | ff[3];
	assign operation[0] = ALUOp[1] & w0;
	
	assign w1 = ~ff[2];
	assign w2 = ~ALUOp[1];
	assign operation[1] = w2 | w1;
	
	assign w3 = ff[1] & ALUOp[1];
	assign operation[2] = w3 | ALUOp[0];
	
endmodule