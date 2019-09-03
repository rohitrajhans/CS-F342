// Detect sequence 10110

module fsm(clk, rst, in, op);
	
	input clk, rst, in;
	output op;
	reg [2:0] state;
	reg op;
	
	always @ (posedge clk, posedge rst)	begin
		if(rst) begin
			state <= 3'b000;
			op <= 0;
		end
		
		else begin
			case(state)
			
				3'b000: begin
					if(in) begin
						state <= 3'b001;
						op <= 0;
					end
					
					else begin
						state <= 3'b000;
						op <= 0;
					end
				end
						
				3'b001: begin
					if(in) begin
						state <= 3'b001;
						op <= 0;
					end
					
					else begin
						state <= 3'b010;
						op <= 0;
					end
				end
						
				3'b010: begin
					if(in) begin
						state <= 3'b011;
						op <= 0;
					end
					
					else begin
						state <= 3'b000;
						op <= 0;
					end
				end
						
				3'b011: begin
					if(in) begin
						state <= 3'b100;
						op <= 1;
					end
					
					else begin
						state <= 3'b010;
						op <= 0;
					end
				end
						
				3'b100: begin
					if(in) begin
						state <= 3'b001;
						op <= 0;
					end
					
					else begin
						state <= 3'b010;
						op <= 0;
					end
				end
						
				default: begin
					state <= 3'b000;
					op <= 0;
				end
			endcase
		end
	end
endmodule

module test;

	reg clk, rst, in;
	wire op;
	reg[15:0] sequence;
	integer i;
	
	fsm duty(clk, rst, in, op);
	
	initial begin
		clk = 0; rst=1;
		sequence = 16'b0101_0111_0111_0110;
		#5 rst = 0;
		
		for(i=0; i<=15; i=i+1) begin
			in = sequence[i];
			#2 clk=1;
			#2 clk=0;
			$display("State = ", duty.state, " Input = ", in, " Output = ",op);
		end
	end
endmodule