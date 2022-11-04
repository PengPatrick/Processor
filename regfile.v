
module regfile (
    clock,
    ctrl_writeEnable,
    ctrl_reset, ctrl_writeReg,
    ctrl_readRegA, ctrl_readRegB, data_writeReg,
    data_readRegA, data_readRegB
);

   input clock, ctrl_writeEnable, ctrl_reset;
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   input [31:0] data_writeReg;

   output [31:0] data_readRegA, data_readRegB;


	//wire [31:0] regOut [31:0];
	wire [31:0] selWri, selA, selB, selEn;
	
	decoder_5to32 decode_wri(ctrl_writeReg, selWri);
	
	genvar i;
	generate 
	for(i = 1;i < 32; i = i + 1) begin: choose_and
		and(selEn[i], selWri[i], ctrl_writeEnable);
	end
	endgenerate
	
	wire [31:0] q0;
	
	decoder_5to32 decoder_readA(ctrl_readRegA, selA);
	decoder_5to32 decoder_readB(ctrl_readRegB, selB);
	register reg_0(32'b0, clock, 1'b0, ctrl_reset, q0);
	tristate tri_A0(q0, selA[0], data_readRegA);
	tristate tri_B0(q0, selB[0], data_readRegB);
	
	genvar j;
	generate
	for(j = 1; j < 32; j = j + 1) begin:reg_id
		wire [31:0] q;
		register reg_j(data_writeReg, clock, selEn[j], ctrl_reset, q);
		tristate tri_A(q, selA[j], data_readRegA);
		tristate tri_B(q, selB[j], data_readRegB);
	end
	endgenerate
	//read_port readA(ctrl_readRegA, regOut, data_readRegA);
	//read_port readB(ctrl_readRegB, regOut, data_readRegB);
endmodule



