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

module decoder2_4 (register, reg_no);
	input [1:0] reg_no;
	output[3:0] register;
	wire not_reg_0, not_reg_1;
	
	not n1(not_reg_0, reg_no[0]);
	not n2(not_reg_1, reg_no[1]);
	
	and a2(register[0], not_reg_0, not_reg_1);
	and a3(register[1], reg_no[0], not_reg_1);
	and a4(register[2], not_reg_0, reg_no[1]);
	and a5(register[3], reg_no[0], reg_no[1]);

endmodule

module writeToReg(q, clk, data);
	input clk;
	input [31:0] data;
	output [31:0] q;
	genvar j;
	
	generate
		for(j=0; j<=31; j=j+1) begin: write_to_reg
			and a(q[j], clk, data[j]);
		end
	endgenerate
endmodule

module RegFile(clk, reset, ReadReg1, ReadReg2, WriteData, WriteReg, RegWrite, ReadData1, ReadData2);
	output [31:0] ReadData1, ReadData2;
	input [31:0] WriteData;
	input clk, reset, RegWrite; // RegWrite is write enable signal
	input [1:0] WriteReg, ReadReg1, ReadReg2;
	
	// Wires are used to pass the outputs between intermediate modules
	// A register is generally used to store conditional outputs
	wire [31:0] q1, q2, q3, q4;
	wire [3:0] clock, decoder_op;
	wire we;
	genvar j;
	
	decoder2_4 d1(decoder_op, WriteReg);
	
	and a1 (we, clk, RegWrite);
	
	generate
		for(j=0; j<=3; j=j+1) begin: set_clock
			and a(clock[j], we, decoder_op[j]);
		end
	endgenerate
	
	// initialize registers to 0
	reg_32bit r1(q1, 32'H00000000, clk, reset);
	reg_32bit r2(q2, 32'H00000000, clk, reset);
	reg_32bit r3(q3, 32'H00000000, clk, reset);
	reg_32bit r4(q4, 32'H00000000, clk, reset);
	
	writeToReg w1(q1, clock[0], WriteData);
	writeToReg w2(q2, clock[1], WriteData);
	writeToReg w3(q3, clock[2], WriteData);
	writeToReg w4(q4, clock[3], WriteData);
	
	mux4_1 m0(ReadData1, q1, q2, q3, q4, ReadReg1);
	mux4_1 m1(ReadData2, q1, q2, q3, q4, ReadReg2);
	
endmodule

// module tb;
	// reg clk;
	// reg [31:0] data;
	// wire [31:0] q;
	
	// writeToReg w(q, clk, data);
	
	// initial begin
		// $monitor(, $time, " q=%b, clk=%b, data=%b", q, clk, data);
		// data = 32'HAFAFAFAF;
		// clk=1'b1;
		// #20 $finish;
	// end
	
// endmodule

module testbench;
	wire [31:0] ReadData1, ReadData2;
	reg [31:0] WriteData;
	reg clk, reset, RegWrite; // RegWrite is write enable signal
	reg [1:0] WriteReg, ReadReg1, ReadReg2;
	
	RegFile r(clk, reset, ReadReg1, ReadReg2, WriteData, WriteReg, RegWrite, ReadData1, ReadData2);
	
	initial begin
		$monitor(, $time, " ReadData1=%b, ReadData2=%b, WriteData=%b", ReadData1, ReadData2, WriteData);
		clk=1; reset=0; ReadReg1=2'b00; ReadReg2=2'b00; WriteReg=2'b00; RegWrite=1'b1;
		WriteData = 32'HAFAFAFAF;
		#20 $finish;
	end
	
endmodule

// module tb32reg;
	// reg [31:0] d;
	// reg clk, reset;
	// wire [31:[0] q;
	
	// reg_32bit R(q, d, clk, reset);
	
	// always @(clk)
		// #5 clk <= ~clk;
		
	// initial begin
		// $monitor(, $time, " q = %b, d = %b, reset=%b", q, d, reset); 
		// clk = 1'b1;
		// reset = 1'b0;
		// #20 reset = 1'b1;
		// #20 d = 32'hAFAFAFAF;
		// #20 d = 32'hAFCFBF0F; clk=1'b0;
		// #20 d = 32'hAC043FAF; clk=1'b1;
		// #20 d = 32'hAFAFA234;
		// #20 d = 32'hAF245A6F;
		// #200 $finish;
	// end
	
	// initial begin
		// $dumpfile("reg_file.vcd");
		// $dumpvars;
	// end
	
// endmodule

// module tb_mux;
	// reg [31:0] q1, q2, q3, q4;
	// reg [1:0] regNo;
	// wire [31:0] regData;

	// mux4_1 m(regData, q1, q2, q3, q4, regNo);
	
	// initial begin
		// $monitor(, $time, " output = %b, q1 = %b, q2 = %b, q3 = %b, q4 = %b", regData, q1, q2, q3, q4);
		
		// q1 = 32'hAFAFAFAF;
		// q2 = 32'hAFCFBF0F;
		// q3 = 32'hAC043FAF;
		// q4 = 32'h00000000;
		// regNo = 2'b00;
		// #20 regNo = 2'b01;
		// #20 regNo = 2'b10;
		// #20 regNo = 2'b11;
		// #20 $finish;
	// end
// endmodule

// module tb_decoder;
	// wire [3:0] register;
	// reg [1:0] reg_no;
	
	// decoder2_4 d(register, reg_no);
	
	// initial begin
		// $monitor(, $time, " register = %b, reg_no = %b", register, reg_no);
		// reg_no = 2'b00;
		// #20 reg_no = 2'b01;
		// #20 reg_no = 2'b10;
		// #20 reg_no = 2'b11;
		// #20 $finish;
	// end
	
// endmodule