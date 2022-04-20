module smallRAM(rw, dataIn, CS, address, clk, dataOut);

	input rw;
	input [7:0] dataIn;
	input [5:0] address;
	input CS;
	input clk;
	
	//wire en = 1;

	parameter adr_width=6;
	
	parameter ram_depth= 1 << adr_width;

	//reg[7:0]memOut;
	reg[7:0]mem[0:ram_depth-1];

	output [7:0] dataOut;


	always@(rw) begin 
	if(CS && rw)  //Write
	mem[address] = dataIn;
	end


	/*always@(rw) begin 
	memOut = mem[address]; //Read
	end*/

	assign dataOut = CS?mem[address]:8'b0;


endmodule 
