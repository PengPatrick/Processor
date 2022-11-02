// Ask TAs if this is allowed
module clock_divider(div_clock, clk, rst);
	
	input clk, rst;
	output reg div_clock;
	
	//这里是不是有点问题
	always @(posedge clk) 
	begin
	if (rst)
		div_clock <= 1'b0;
	else
		div_clock <= ~div_clock;
	end
	
endmodule
