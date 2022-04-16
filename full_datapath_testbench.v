module full_datapath_testbench;

//inputs
//reg [31:0] address;
reg clk, reset, RegWrite, MemRW, MemtoReg, PCsrc, ALUsrc;
reg [3:0] opcode;
//Opcode will have to be [2:0] in final project

//outputs
wire [31:0] PC_next;
wire [31:0] finalout;
//wire [31:0] Read1, Read2;

//(address, clk, reset, opcode, ALUsrc, RegWrite, MemRW, MemtoReg, PCsrc, I, PC_next)
full_datapath dut(.clk(clk), .reset(reset), .opcode(opcode), 
						.ALUsrc(ALUsrc), .RegWrite(RegWrite), .MemRW(MemRW), 
						.MemtoReg(MemtoReg), .PCsrc(PCsrc), .PC_next(PC_next), .finalout(finalout));


						
initial begin
//Alternate Clk, Switch Off Reset From 1 to 0 and keep at 0 for rest of operations
//address always starts at 0, take output and put into next input 
//ALUsrc (read2_Mux) 1 = IMM, 0 = RS2
//RegWrite 1 = write, 0 = nothing
//MemRW (SW) 1 = Write Also, 0 = Just Read
//MemtoReg (mem_Mux) 1 = RAMout data, 0 = result (from ALU operation)
//PCsrc (pc_Mux) 1 = Jump (Not Using), 0 = +4
//opcode -> read ALU, not writing here :)

	reset = 1;
	clk = 0;

	
	#50;
	
	clk = 1;
	
	#50;
	
	clk = 0;
	reset = 0;
	
	#50;
	
	//Setup
	
	clk = 1;
	reset = 1;
	
	ALUsrc = 1;
	RegWrite = 1;
	MemtoReg = 1;
	PCsrc = 0;
	opcode = 0001;
	MemRW = 0;
	
	#50;
	
	clk = 0;
	
	#50;
	
	
	//Test Addi save to mem
	
	clk = 1;
	reset = 0;
	
	ALUsrc = 1;
	RegWrite = 1;
	MemtoReg = 0;
	PCsrc = 0;
	opcode = 0001;
	MemRW = 1;
	
	#50;
	
	clk = 0;
	
	/*
	ALUsrc = 1;
	RegWrite = 0;
	MemtoReg = 1;
	PCsrc = 0;
	opcode = 0001;
	MemRW = 0;
	*/
	
	
	//Test LW -> ALU opcode and other doesn't matter, check datapath block 
	//memtoreg should be 1
	//RegWrite should be 1
	//All else should be 0
	#50;
	
	clk = 1;
	
	ALUsrc = 1;
	RegWrite = 1;
	MemtoReg = 1;
	PCsrc = 0;
	opcode = 0001;
	MemRW = 0;
	
	#50;
	
	clk = 0;
	
	
	#50;
	
	clk = 0;
	
	#50;
	
	$stop;
	

end

endmodule 