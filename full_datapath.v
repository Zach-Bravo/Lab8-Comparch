module full_datapath(clk, reset, opcode, ALUsrc, RegWrite, 
							MemRW, MemtoReg, PCsrc, PC_next, finalout);

//Input CU Controls: RegWrite, ALUsrc, MemRW, PCsrc, MemToReg

//wire [31:0] address;
input [3:0] opcode;
input RegWrite, MemRW, MemtoReg, PCsrc, ALUsrc; //1 or 0

output [31:0] PC_next; //May Replace As Needed
output [31:0] finalout;

input clk, reset;

//Block to Block inputs/outputs
//PC: PCin=32bit, PCout=32bit
wire [31:0] PC_address;

//READ/ROM PCout-> in, RS1/RS2/RD out, IMM out.
wire [31:0] ROMout;
wire [4:0] RD, RS1, RS2;
wire [11:0] IMM;
//IMM Gen IMM-> in, IMM_full out.
wire [31:0] IMM_full;
//Read2 Mux RS2 & IMM_full -> in, Read2 out.
//RegFile
wire [31:0] Read1;
wire [31:0] Read2;
wire [31:0] RS2_full;
//ALU
wire [31:0] result;
//MEM 
wire [3:0] status;
//wire [31:0]regRW_data;


wire [31:0] RAMout;
wire [7:0] RAMout_small1;
wire [7:0] RAMout_small2;
wire [7:0] RAMout_small3;
wire [7:0] RAMout_small4;

//PC Mux potNext1 & potNext2 (updated + Jump) -> PC_out
wire [31:0] potNext1;
wire [31:0] potNext2;


//PC u1 (address, clk, reset, PC_address);
PC u1 (PC_next, clk, reset, PC_address);

//adderFour(next, outAddr);
adderFour u2 (PC_address, potNext1);

//ROM  (addr, dout);
ROM u3 (PC_address, ROMout);

//instructionDecoder(in,rd, rs1,rs2,imm);
instructionDecoder u4(ROMout, RD, RS1, RS2, IMM);

//module imm_generator(in, imm);
imm_generator u5(IMM, IMM_full);

//RegFile (I, clk, reset, rs1, rs2, rd, writeEn, out, out1);
RegFile u6(finalout, clk, reset, RS1, RS2, RD, RegWrite, Read1, RS2_full);		


//Mux -> 0 = RS2, 1 = IMM
read2_Mux u7(ALUsrc, RS2_full, IMM_full, Read2);
//read2_Mux  (ALUsrc, RS2_full, IMM_full, Read2);

//ALU(A, B, opcode, STATUS, FINAL,Cin); status[2] = zero value
ALU u8(Read1, Read2, opcode, status, result, 0);

//module RAM (Din, address, Dout, clk, rw);
//Used to be RAM u8(result, RS2_full, RAMout, clk, MemRW);
RAM u9(RS2_full, result[31:24], RAMout_small1, clk, MemRW);
RAM u10(RS2_full, result[23:16], RAMout_small2, clk, MemRW);
RAM u11(RS2_full, result[15:8], RAMout_small3, clk, MemRW);
RAM u12(RS2_full, result[7:0], RAMout_small4, clk, MemRW);

assign RAMout[31:24] = RAMout_small1;
assign RAMout[23:16] = RAMout_small2;
assign RAMout[15:8]  = RAMout_small3;
assign RAMout[7:0]   = RAMout_small4;

//Mux -> MemMux
mem_Mux u13(MemtoReg, result, RAMout, finalout);


//Adder -> Jump
FullAdder u14(PC_address, IMM_full, 0, potNext2, status);

//Mux -> Next PCout aka PC_next
pc_Mux u15(PCsrc, potNext1, potNext2, PC_next);


endmodule


