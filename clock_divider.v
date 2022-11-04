// Ask TAs if this is allowed
module clock_divider(div_clock, clk, rst);
	
	input clk, rst;
	output reg div_clock;
	
<<<<<<< HEAD
	always @(posedge clk or posedge rst) 
	begin
	if (~rst)
=======
	//这里是不是有点问题
	always @(posedge clk) 
	begin
	if (rst)
>>>>>>> cffac3166ebc375e41d1368628e102358a1a1fb4
		div_clock <= 1'b0;
	else
		div_clock <= ~div_clock;
	end
	
endmodule
