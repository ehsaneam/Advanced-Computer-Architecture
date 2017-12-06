module cache(clk , rst , memory_address , write_data_block , write_data_word, read_data_word 
				, read_data_block, hit , we_block , we_word , addout,dirty);
	input [31:0] memory_address,write_data_word;
	input [511:0] write_data_block;
	input clk,rst,we_block,we_word;
	output [511:0] read_data_block;
	output reg[31:0] read_data_word;
	output [31:0] addout;
	output hit,dirty;
	
	wire [3:0] block_offset;
	wire [8:0] shifted_block_offset;
	wire [25:0] tag,cache_tag;
	wire valid;
	
	reg [539:0]cache_data;
	
	always@(posedge clk)begin
		if(~rst)begin
			cache_data[539:512] <= {1'b0,1'b0,tag};
		end
		else begin
		case(block_offset)
			4'b0000:read_data_word <= cache_data[31:0];
			4'b0001:read_data_word <= cache_data[63:32];
			4'b0010:read_data_word <= cache_data[95:64];
			4'b0011:read_data_word <= cache_data[127:96];
			4'b0100:read_data_word <= cache_data[159:128];
			4'b0101:read_data_word <= cache_data[191:160];
			4'b0110:read_data_word <= cache_data[223:192];
			4'b0111:read_data_word <= cache_data[255:224];
			4'b1000:read_data_word <= cache_data[287:256];
			4'b1001:read_data_word <= cache_data[319:288];
			4'b1010:read_data_word <= cache_data[351:320];
			4'b1011:read_data_word <= cache_data[383:352];
			4'b1100:read_data_word <= cache_data[415:384];
			4'b1101:read_data_word <= cache_data[447:416];
			4'b1110:read_data_word <= cache_data[479:448];
			4'b1111:read_data_word <= cache_data[511:480];
		endcase
		if(we_block)begin
			cache_data[511:0] <= write_data_block;
			cache_data[539:512] <= {1'b1,1'b0,tag};
		end
		if(we_word)begin
			case(block_offset)
				4'b0000:cache_data[31:0] <= write_data_word;
				4'b0001:cache_data[63:32] <= write_data_word;
				4'b0010:cache_data[95:64] <= write_data_word;
				4'b0011:cache_data[127:96] <= write_data_word;
				4'b0100:cache_data[159:128] <= write_data_word;
				4'b0101:cache_data[191:160] <= write_data_word;
				4'b0110:cache_data[223:192] <= write_data_word;
				4'b0111:cache_data[255:224] <= write_data_word;
				4'b1000:cache_data[287:256] <= write_data_word;
				4'b1001:cache_data[319:288] <= write_data_word;
				4'b1010:cache_data[351:320] <= write_data_word;
				4'b1011:cache_data[383:352] <= write_data_word;
				4'b1100:cache_data[415:384] <= write_data_word;
				4'b1101:cache_data[447:416] <= write_data_word;
				4'b1110:cache_data[479:448] <= write_data_word;
				4'b1111:cache_data[511:480] <= write_data_word;
			endcase
			cache_data[538] <= 1'b1;
			cache_data[539] <= 1'b1;
		end
		end
	end
	assign read_data_block = cache_data[511:0];
	assign hit = (cache_tag == tag) & valid;
	assign block_offset = memory_address[5:2];
	assign shifted_block_offset = {block_offset,5'b0};
	assign tag = memory_address[31:6];
	assign cache_tag = cache_data[537:512];
	assign addout = {cache_tag,6'b0};
	assign dirty = cache_data[538];
	assign valid = cache_data[539];
endmodule