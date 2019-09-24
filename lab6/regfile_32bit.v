module decoder5_32(register, reg_no);
	input [4:0] reg_no;
	output[31:0] register;
	
	assign register[0] = (~reg_no[4] & ~reg_no[3] & ~reg_no[2] & ~reg_no[1] & ~reg_no[0]);
	assign register[1] = (~reg_no[4] & ~reg_no[3] & ~reg_no[2] & ~reg_no[1] & reg_no[0]);
	assign register[2] = (~reg_no[4] & ~reg_no[3] & ~reg_no[2] & reg_no[1] & ~reg_no[0]);
	assign register[3] = (~reg_no[4] & ~reg_no[3] & ~reg_no[2] & reg_no[1] & reg_no[0]);
	assign register[4] = (~reg_no[4] & ~reg_no[3] & reg_no[2] & ~reg_no[1] & ~reg_no[0]);
	assign register[5] = (~reg_no[4] & ~reg_no[3] & reg_no[2] & ~reg_no[1] & reg_no[0]);
	assign register[6] = (~reg_no[4] & ~reg_no[3] & reg_no[2] & reg_no[1] & ~reg_no[0]);
	assign register[7] = (~reg_no[4] & ~reg_no[3] & reg_no[2] & reg_no[1] & reg_no[0]);
	assign register[8] = (~reg_no[4] & reg_no[3] & ~reg_no[2] & ~reg_no[1] & ~reg_no[0]);
	assign register[9] = (~reg_no[4] & reg_no[3] & ~reg_no[2] & ~reg_no[1] & reg_no[0]);
	assign register[10] = (~reg_no[4] & reg_no[3] & ~reg_no[2] & reg_no[1] & ~reg_no[0]);
	assign register[11] = (~reg_no[4] & reg_no[3] & ~reg_no[2] & reg_no[1] & reg_no[0]);
	assign register[12] = (~reg_no[4] & reg_no[3] & reg_no[2] & ~reg_no[1] & ~reg_no[0]);
	assign register[13] = (~reg_no[4] & reg_no[3] & reg_no[2] & ~reg_no[1] & reg_no[0]);
	assign register[14] = (~reg_no[4] & reg_no[3] & reg_no[2] & reg_no[1] & ~reg_no[0]);
	assign register[15] = (~reg_no[4] & reg_no[3] & reg_no[2] & reg_no[1] & reg_no[0]);
	
	assign register[16] = (reg_no[4] & ~reg_no[3] & ~reg_no[2] & ~reg_no[1] & ~reg_no[0]);
	assign register[17] = (reg_no[4] & ~reg_no[3] & ~reg_no[2] & ~reg_no[1] & reg_no[0]);
	assign register[18] = (reg_no[4] & ~reg_no[3] & ~reg_no[2] & reg_no[1] & ~reg_no[0]);
	assign register[19] = (reg_no[4] & ~reg_no[3] & ~reg_no[2] & reg_no[1] & reg_no[0]);
	assign register[20] = (reg_no[4] & ~reg_no[3] & reg_no[2] & ~reg_no[1] & ~reg_no[0]);
	assign register[21] = (reg_no[4] & ~reg_no[3] & reg_no[2] & ~reg_no[1] & reg_no[0]);
	assign register[22] = (reg_no[4] & ~reg_no[3] & reg_no[2] & reg_no[1] & ~reg_no[0]);
	assign register[23] = (reg_no[4] & ~reg_no[3] & reg_no[2] & reg_no[1] & reg_no[0]);
	assign register[24] = (reg_no[4] & reg_no[3] & ~reg_no[2] & ~reg_no[1] & ~reg_no[0]);
	assign register[25] = (reg_no[4] & reg_no[3] & ~reg_no[2] & ~reg_no[1] & reg_no[0]);
	assign register[26] = (reg_no[4] & reg_no[3] & ~reg_no[2] & reg_no[1] & ~reg_no[0]);
	assign register[27] = (reg_no[4] & reg_no[3] & ~reg_no[2] & reg_no[1] & reg_no[0]);
	assign register[28] = (reg_no[4] & reg_no[3] & reg_no[2] & ~reg_no[1] & ~reg_no[0]);
	assign register[29] = (reg_no[4] & reg_no[3] & reg_no[2] & ~reg_no[1] & reg_no[0]);
	assign register[30] = (reg_no[4] & reg_no[3] & reg_no[2] & reg_no[1] & ~reg_no[0]);
	assign register[31] = (reg_no[4] & reg_no[3] & reg_no[2] & reg_no[1] & reg_no[0]);

endmodule

module d_ff(q, d, clk, reset);
	input d, clk, reset;
	output q;
	reg q;
	
	always @(posedge clk) begin
		if( !reset) q <= 1'b0;
		else q <= d;
	end
	
endmodule

module reg_32bit(q, d, clk, reset);
	input[31:0] d; 
	input clk, reset;
	output[31:0] q;
	genvar j;
	
	generate
		for( j=0; j<=31; j=j+1) begin: reg_loop
			d_ff m(q[j], d[j], clk, reset);
		end
	endgenerate
	
endmodule

module mux4to1(out, sel1, sel2, in1, in2, in3, in4);
	input in1, in2, in3, in4, sel1, sel2;
	output out;
	wire not_sel1, not_sel2, a1, a2, a3, a4, a5, a6, a7;
	
	not (not_sel1, sel1);
	not (not_sel2, sel2);
	
	and (a1, not_sel1, not_sel2);
	and (a2, not_sel1, sel2);
	and (a3, sel1, not_sel2);
	and (a4, sel1, sel2);
	
	and (a5, a1, in1);
	and (a6, a3, in2);
	and (a7, a2, in3);
	and (a8, a4, in4);
	
	or (a9, a5, a6);
	or (a10, a9, a7);
	or (out, a10, a8);
endmodule

module mux4_1 (regData, q1, q2, q3, q4, reg_no);
	input [31:0] q1, q2, q3, q4;
	input [1:0] reg_no;
	output [31:0] regData;
	
	genvar j;
	
	generate
		for(j=0; j<=31; j=j+1) begin: mux_loop
			mux4to1 m(regData[j], reg_no[0], reg_no[1], q1[j], q2[j], q3[j], q4[j]);
		end
	endgenerate
	
endmodule

module mux32_1(out, data, select);
	output [31:0] out;
	input [4:0] select;
	input [31:0] data[31:0];
	reg [31:0] out;
	
	always @ (data[0] or data[1] or data[2] or data[3] or data[4] or data[5] or data[6] or data[7] or data[8] or data[9] or data[10] or data[11] or data[12] or data[13] or data[14] or data[15] or data[16] or data[17] or data[18] or data[19] or data[20] or data[21] or data[22] or data[23] or data[24] or data[25] or data[26] or data[27] or data[28] or data[29] or data[30] or data[31] or select)
	case  (select)
		5'b00000: out = data[0];
		5'b00001: out = data[1];
		5'b00010: out = data[2];
		5'b00011: out = data[3];
		5'b00100: out = data[4];
		5'b00101: out = data[5];
		5'b00110: out = data[6];
		5'b00111: out = data[7];
		5'b01000: out = data[8];
		5'b01001: out = data[9];
		5'b01010: out = data[10];
		5'b01011: out = data[11];
		5'b01100: out = data[12];
		5'b01101: out = data[13];
		5'b01110: out = data[14];
		5'b01111: out = data[15];
		5'b10000: out = data[16];
		5'b10001: out = data[17];
		5'b10010: out = data[18];
		5'b10011: out = data[19];
		5'b10100: out = data[20];
		5'b10101: out = data[21];
		5'b10110: out = data[22];
		5'b10111: out = data[23];
		5'b11000: out = data[24];
		5'b11001: out = data[25];
		5'b11010: out = data[26];
		5'b11011: out = data[27];
		5'b11100: out = data[28];
		5'b11101: out = data[29];
		5'b11110: out = data[30];
		5'b11111: out = data[31];
    
	endcase

endmodule

module regfile_32(clk, reset, ReadReg1, ReadReg2, WriteData, WriteReg, RegWrite, ReadData1, ReadData2);
	input clk, reset, RegWrite;
	input [4:0] WriteReg, ReadReg1, ReadReg2;
	input [31:0] WriteData;
	output [31:0] ReadData1, ReadData2;
	wire [31:0] opcode, clock;
	wire [31:0] q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13, q14, q15, q16;
	wire [31:0] q17, q18, q19, q20, q21, q22, q23, q24, q25, q26, q27, q28, q29, q30, q31, q32;
	wire [31:0] data [31:0];
	genvar j;
	
	decoder5_32 d1(decoder_op, WriteReg);
	and a1 (we, clk, RegWrite);
	
	generate
		for(j=0; j<=31; j=j+1) begin: set_clock
			and a(clock[j], we, decoder_op[j]);
		end
	endgenerate
	
	generate
		for(j=0; j<=31; j=j+1) begin: write_data
			reg_32bit r(data[j], WriteData, clock[j], reset);
		end
	endgenerate
	
	mux32_1 m0(ReadData1, data, ReadReg1);
	mux32_1 m1(ReadData2, data, ReadReg2);
	
endmodule