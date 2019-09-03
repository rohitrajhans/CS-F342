module dff_sync_clear(d, clearb, clock, q);

	input d, clearb, clock;
	output q;
	reg q;
	
	always @ (posedge clock)
		begin
			if (!clearb) q <= 1'b0;
			else q <= d;
		end
endmodule

module dff_async_clear(d, clearb, clock, q);

	input d,clearb, clock;
	output q;
	reg q;
	
	always @ (negedge clearb or posedge clock)
		begin
			if(!clearb) q<=1'b0;
			else q<=d;
		end
endmodule

module Testing;

	reg d, clk, rst;
	wire q;
	
	dff_sync_clear dff(d, rst, clk, q);
	
	always @ (posedge clk) begin
		$display ("d=%b, clk=%b, rst=%b, q=%b\n", d, clk, rst, q);
	end
	
	initial begin
		//forever begin
			clk = 0;
			#5 clk = 1;
			#5 clk = 0;
			#5 clk = 1;
			#5 clk = 0;
			#5 clk = 1;
			#5 clk = 0;
		//end
	end
	
	initial begin
		d=0; rst=1;
		#5 d=1; rst=1;
		#10 d=1; rst=1;
		#15 d=0; rst=0;
	end
	
	initial begin
		$dumpfile("dff.vcd");
		$dumpvars;
	end
	
endmodule