module pc(
	input clk,
	input [31:0] in,
	input clr,
	output reg [31:0] out
	);

 initial begin
    out <= 32'b0;
 end
 
 always @(posedge clk) begin
	out = clr ? 32'b0 : in;
 end

endmodule
	