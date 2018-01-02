module cache_top(clk , rst, INWriteReg , memtoreg , memwrite , INAddress , INWriteData , hit , read_data_word , cache_dataReady , OUTWriteReg);
	input clk , rst , memtoreg , memwrite;
	input [31:0] INAddress,INWriteData;
	input [4:0] INWriteReg;
	output [4:0] OUTWriteReg;
	output hit,cache_dataReady;
	output [31:0] read_data_word;
	
	wire dirty_cache2cc, we_cc2dm,we_block_cc2cache,bufferLostWD_enable,we_word_cc2cache,WritebackSignal,CacheLdFromBuffer;
	wire [31:0] A,AD_cache2DM,Address_DM,WriteDataWord_cache,cache_add,cache_readdata_word;
	wire [511:0] WriteData_DM,writeback2DM,WriteDataBlock_DM2cache;
	reg [31:0] Address_DM_reg,bufferLostWD,bufferLostAD,bufferWBAD;
	reg [511:0] write_buffer,WriteData_DM_reg;
	reg[4:0] OUTWriteReg_buf;
	
	cache_controller CC(clk, rst, hit, dirty_cache2cc, memtoreg, memwrite, we_cc2dm, we_word_cc2cache,
					we_block_cc2cache, bufferLostWD_enable , WritebackSignal,CacheLdFromBuffer,cache_dataReady);
	Data_Memory DM(clk, we_cc2dm, Address_DM, WriteData_DM, WriteDataBlock_DM2cache);
	cache Cache(clk ,rst, cache_add , WriteDataBlock_DM2cache , WriteDataWord_cache, cache_readdata_word ,
					writeback2DM, hit , we_block_cc2cache , we_word_cc2cache, AD_cache2DM,dirty_cache2cc);
	
	always@(posedge clk)begin
		if(memtoreg)
			OUTWriteReg_buf <= INWriteReg;
		if(memtoreg | memwrite | we_cc2dm)
			Address_DM_reg <= Address_DM;
		if(we_cc2dm)
			WriteData_DM_reg <= WriteData_DM;
		if(bufferLostWD_enable)begin
			bufferLostWD <= INWriteData;
		end
		if(WritebackSignal)begin
			write_buffer <= writeback2DM;
			bufferWBAD <= AD_cache2DM;
			bufferLostAD <= INAddress;
		end
	end
	assign WriteDataWord_cache = (CacheLdFromBuffer)?bufferLostWD:INWriteData;
	assign cache_add = (we_block_cc2cache|CacheLdFromBuffer)?bufferLostAD:INAddress;
	assign A = (we_cc2dm)? bufferWBAD : INAddress;
	assign Address_DM = (memtoreg | memwrite | we_cc2dm)? A : Address_DM_reg;
	assign WriteData_DM = (we_cc2dm)? write_buffer : WriteData_DM_reg;
	assign read_data_word = 
		({we_block_cc2cache,bufferLostAD[5:2]}==5'b10000)?WriteDataBlock_DM2cache[31:0]:
		({we_block_cc2cache,bufferLostAD[5:2]}==5'b10001)?WriteDataBlock_DM2cache[63:32]:
		({we_block_cc2cache,bufferLostAD[5:2]}==5'b10010)?WriteDataBlock_DM2cache[95:64]:
		({we_block_cc2cache,bufferLostAD[5:2]}==5'b10011)?WriteDataBlock_DM2cache[127:96]:
		({we_block_cc2cache,bufferLostAD[5:2]}==5'b10100)?WriteDataBlock_DM2cache[159:128]:
		({we_block_cc2cache,bufferLostAD[5:2]}==5'b10101)?WriteDataBlock_DM2cache[191:160]:
		({we_block_cc2cache,bufferLostAD[5:2]}==5'b10110)?WriteDataBlock_DM2cache[223:192]:
		({we_block_cc2cache,bufferLostAD[5:2]}==5'b10111)?WriteDataBlock_DM2cache[255:224]:
		({we_block_cc2cache,bufferLostAD[5:2]}==5'b11000)?WriteDataBlock_DM2cache[287:256]:
		({we_block_cc2cache,bufferLostAD[5:2]}==5'b11001)?WriteDataBlock_DM2cache[319:288]:
		({we_block_cc2cache,bufferLostAD[5:2]}==5'b11010)?WriteDataBlock_DM2cache[351:320]:
		({we_block_cc2cache,bufferLostAD[5:2]}==5'b11011)?WriteDataBlock_DM2cache[383:352]:
		({we_block_cc2cache,bufferLostAD[5:2]}==5'b11100)?WriteDataBlock_DM2cache[415:384]:
		({we_block_cc2cache,bufferLostAD[5:2]}==5'b11101)?WriteDataBlock_DM2cache[447:416]:
		({we_block_cc2cache,bufferLostAD[5:2]}==5'b11110)?WriteDataBlock_DM2cache[479:448]:
		({we_block_cc2cache,bufferLostAD[5:2]}==5'b11111)?WriteDataBlock_DM2cache[511:480]:
		cache_readdata_word;
	assign OUTWriteReg = (memtoreg)? INWriteReg:OUTWriteReg_buf;
endmodule