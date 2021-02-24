module top (	input         clk, reset,
		output [31:0] data_to_mem, address_to_mem,
		output        write_enable);

	wire [31:0] pc, instruction, data_from_mem;

	inst_mem  imem(pc[7:2], instruction);
	data_mem  dmem(clk, write_enable, address_to_mem, data_to_mem, data_from_mem);
	processor CPU(clk, reset, pc, instruction, write_enable, address_to_mem, data_to_mem, data_from_mem);
endmodule

//-------------------------------------------------------------------
module data_mem (input clk, we,
		 input  [31:0] address, wd,
		 output [31:0] rd);

	reg [31:0] RAM[63:0];

    integer i;
	initial begin
	   $readmemh("datasort.mem",RAM,0,63);
//		RAM[0] = 42;
//		for (i = 1; i < 64; i = i + 1) begin
//		    RAM[i] = 0;
//		end
        
	end

	assign rd=RAM[address[31:2]]; // word aligned

	always @ (posedge clk)
		if (we)
			RAM[address[31:2]]<=wd;
endmodule

//-------------------------------------------------------------------
module inst_mem (input  [5:0]  address,
		 output [31:0] rd);

	reg [31:0] RAM[63:0];
	initial begin
	    //$readmemh("hexsort.mem",RAM,0,63);
//		RAM[0] = 32'b100011_00000_01101_0000_0000_0000_0000; // lw from 0x0 to 13
//		RAM[1] = 32'b001000_00000_01100_0000_0000_0100_0101; // addi 69 to 12
//		RAM[2] = 32'b000000_01101_01100_0111_0000_0010_0000; // add 12 13 to 14
//        RAM[3] = 32'b101011_00000_01110_0000_0000_0000_1000; // sw 14 to 0x8
//        RAM[4] = 32'b000000_01110_01100_1000_0000_0010_0010; // sub 14 - 12 to 16
//        RAM[5] = 32'b000100_10000_00000_0000_0000_0000_0000; // beq 16 == 0
//        //RAM[6] = 32'b000100_00000_01111_1111_1111_1111_1001; beq
//        //RAM[6] = 32'b000111_00000_00000_0000_0000_0000_1000; jr
//        RAM[6] = 32'b001000_00000_00001_0000_0000_0000_1101; // addi 13 to 1
//        RAM[7] = 32'b001000_00000_00010_0000_0000_0000_1011; // addi 11 to 2
//        RAM[8] = 32'b000000_00001_00010_0001_1000_0010_0100; // and 1 2
//        RAM[9] = 32'b000000_00001_00010_0010_0000_0010_0101; // or 1 2
//        RAM[10] = 32'b000000_00001_00010_0010_1000_0010_1010; // slt 1<2
//        RAM[11] = 32'b000000_00010_00001_0011_0000_0010_1010; // slt 2>1
//        //RAM[12] = 32'b000011_00000_00000_0000_0000_1111_1111; // jal
//        RAM[12] = 32'b011111_00000_00000_0000_0000_0001_0000;
//        RAM[13] = 32'b100011_00000_00000_0000_0000_0000_0000; // lw from 0x0 to 13
//        RAM[14] = 32'b001000_00000_00000_0000_0000_0100_0101; // addi 69 to 12
          RAM[0] = 32'b001000_00000_00001_1000_0000_1111_1111; // addi 13 to 1
          RAM[1] = 32'b001000_00000_00010_0000_0000_0000_0100; // addi 11 to 2
          RAM[2] = 32'b000000_00010_00001_0010_0000_0000_0100;
          RAM[3] = 32'b000000_00010_00001_0010_1000_0000_0110;
          RAM[4] = 32'b000000_00010_00001_0011_0000_0000_0111;
          RAM[5] = 32'b000010_00000_00000_0000_0000_1111_1111;
         
	end
	assign rd=RAM[address]; // word aligned
endmodule
