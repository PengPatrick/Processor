/**
 * NOTE: you should not need to change this file! This file will be swapped out for a grading
 * "skeleton" for testing. We will also remove your imem and dmem file.
 *
 * NOTE: skeleton should be your top-level module!
 *
 * This skeleton file serves as a wrapper around the processor to provide certain control signals
 * and interfaces to memory elements. This structure allows for easier testing, as it is easier to
 * inspect which signals the processor tries to assert when.
 */
<<<<<<< HEAD

module skeleton(clock, reset, imem_clock, dmem_clock, processor_clock, regfile_clock);
    input clock, reset;
    /* 
=======
/*
module skeleton(clock, reset, imem_clock, dmem_clock, processor_clock, regfile_clock);
    input clock, reset;
     
>>>>>>> cffac3166ebc375e41d1368628e102358a1a1fb4
        Create four clocks for each module from the original input "clock".
        These four outputs will be used to run the clocked elements of your processor on the grading side. 
        You should output the clocks you have decided to use for the imem, dmem, regfile, and processor 
        (these may be inverted, divided, or unchanged from the original clock input). Your grade will be 
        based on proper functioning with this clock.
<<<<<<< HEAD
    */
    output imem_clock, dmem_clock, processor_clock, regfile_clock;
=======
    
    output imem_clock, dmem_clock, processor_clock, regfile_clock;
*/
module skeleton(
	input clock, reset,
	output imem_clock, dmem_clock, processor_clock, regfile_clock,
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB,
	output [11:0] address_dmem, address_imem,
	output [31:0] data, data_writeReg, data_readRegA, data_readRegB,
	output [31:0] q_imem, operand_B,
	output overflow, status_en
	);

	 
	 /*My Code Here*/
	 wire regfile_clock_t;
	 assign imem_clock = clock;
	 assign dmem_clock = clock;
	 clock_divider clk_Regfile(regfile_clock_t, clock, reset);
	 clock_divider clk_Processor(processor_clock, regfile_clock_t, reset);
	 assign regfile_clock = processor_clock;
	 
>>>>>>> cffac3166ebc375e41d1368628e102358a1a1fb4

    /** IMEM **/
    // Figure out how to generate a Quartus syncram component and commit the generated verilog file.
    // Make sure you configure it correctly!
<<<<<<< HEAD
    wire [11:0] address_imem;
    wire [31:0] q_imem;
=======
    //wire [11:0] address_imem;
    //wire [31:0] q_imem;
>>>>>>> cffac3166ebc375e41d1368628e102358a1a1fb4
    imem my_imem(
        .address    (address_imem),            // address of data
        .clock      (imem_clock),                  // you may need to invert the clock
        .q          (q_imem)                   // the raw instruction
    );

    /** DMEM **/
    // Figure out how to generate a Quartus syncram component and commit the generated verilog file.
    // Make sure you configure it correctly!
<<<<<<< HEAD
    wire [11:0] address_dmem;
    wire [31:0] data;
    wire wren;
    wire [31:0] q_dmem;
    dmem my_dmem(
        .address    (/* 12-bit wire */),       // address of data
        .clock      (dmem_clock),                  // may need to invert the clock
        .data	    (/* 32-bit data in */),    // data you want to write
        .wren	    (/* 1-bit signal */),      // write enable
        .q          (/* 32-bit data out */)    // data from dmem
=======
    //wire [11:0] address_dmem;
    //wire [31:0] data;
    wire wren;
    wire [31:0] q_dmem;
    dmem my_dmem(
        .address    (/* 12-bit wire */address_dmem),       // address of data
        .clock      (dmem_clock),                  // may need to invert the clock
        .data	    (/* 32-bit data in k*/data),    // data you want to write
        .wren	    (/* 1-bit signal */wren),      // write enable
        .q          (/* 32-bit data out */q_dmem)    // data from dmem
>>>>>>> cffac3166ebc375e41d1368628e102358a1a1fb4
    );

    /** REGFILE **/
    // Instantiate your regfile
    wire ctrl_writeEnable;
<<<<<<< HEAD
    wire [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    wire [31:0] data_writeReg;
    wire [31:0] data_readRegA, data_readRegB;
=======
    //wire [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    //wire [31:0] data_writeReg;
    //wire [31:0] data_readRegA, data_readRegB;
>>>>>>> cffac3166ebc375e41d1368628e102358a1a1fb4
    regfile my_regfile(
        regfile_clock,
        ctrl_writeEnable,
        reset,
        ctrl_writeReg,
        ctrl_readRegA,
        ctrl_readRegB,
        data_writeReg,
        data_readRegA,
        data_readRegB
    );

    /** PROCESSOR **/
<<<<<<< HEAD
    processor my_processor(
=======
    processor my_processor( 
>>>>>>> cffac3166ebc375e41d1368628e102358a1a1fb4
        // Control signals
        processor_clock,                          // I: The master clock
        reset,                          // I: A reset signal

        // Imem
        address_imem,                   // O: The address of the data to get from imem
        q_imem,                         // I: The data from imem

        // Dmem
        address_dmem,                   // O: The address of the data to get or put from/to dmem
        data,                           // O: The data to write to dmem
        wren,                           // O: Write enable for dmem
        q_dmem,                         // I: The data from dmem

        // Regfile
        ctrl_writeEnable,               // O: Write enable for regfile
        ctrl_writeReg,                  // O: Register to write to in regfile
        ctrl_readRegA,                  // O: Register to read from port A of regfile
        ctrl_readRegB,                  // O: Register to read from port B of regfile
        data_writeReg,                  // O: Data to write to for regfile
        data_readRegA,                  // I: Data from port A of regfile
<<<<<<< HEAD
        data_readRegB                   // I: Data from port B of regfile
=======
        data_readRegB,                  // I: Data from port B of regfile
		  operand_B,
		  overflow,
		  status_en
>>>>>>> cffac3166ebc375e41d1368628e102358a1a1fb4
    );

endmodule
