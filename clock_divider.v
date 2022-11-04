// Ask TAs if this is allowed
/*
module clock_divider(div_clock, clk, rst);
	
	input clk, rst;
	output reg div_clock;
	
	always @(posedge clk) // or posedge rst) 
	begin
	if (rst)
		div_clock <= 1'b0;
	else
		div_clock <= ~div_clock;
	end
	
endmodule
*/
module clock_divider(clk,reset, clk_out);
 
	input clk;
	input reset;
	output clk_out;
	 
	reg [1:0] r_reg;
	wire [1:0] r_nxt;
	reg clk_track;
	 
	always @(posedge clk or posedge reset)
	 
	begin
	  if (reset)
		  begin
			  r_reg <= 3'b0;
		clk_track <= 1'b0;
		  end
	 
	  else if (r_nxt == 2'b10)
			begin
			  r_reg <= 0;
			  clk_track <= ~clk_track;
			end
	 
	  else 
			r_reg <= r_nxt;
	end
	 
	 assign r_nxt = r_reg+1;   	      
	 assign clk_out = clk_track;
	 
endmodule
