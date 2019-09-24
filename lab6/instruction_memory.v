module inst_mem(instruction, pc, clock);
	input clock;
	input [31:0] pc;
	output [31:0] instruction;
	reg [31:0] mem [0:31];
	reg [31:0] instruction;
	integer addr;
	genvar j;
	
	generate
		for(j=0; j<32; j=j+1) begin: initialize_memory
			mem[j] = 32'H00000000;
		end
	endgenerate
	
    mem[3] = 32'b10001100000100010000000000001000;  // lw  $s1($17), 8($0)
    mem[4] = 32'b10001100000100100000000000000100;  // lw  $s2($18), 4($0)
    mem[5] = 32'b00000010001100100100000000100000;  // add $t0($8), $s1($17), $s2($18)
	
	always @(posedge clock)
		addr = pc[31:0];
		instruction = mem[addr];
	end
	
endmodule