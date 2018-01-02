module cache_controller(clk,rst,hit,dirty,memtoreg,memwrite,DM_WE,cache_we_word,cache_we_block,WriteData_Buffer,WritebackSignal,CacheLdFromBuffer,cache_dataReady);
	
	input clk , hit , dirty , rst , memtoreg , memwrite;
	output reg DM_WE,cache_we_word,WriteData_Buffer,WritebackSignal,cache_we_block,CacheLdFromBuffer,cache_dataReady;
	
	parameter IDLE = 3'd0, READLOST = 3'd1, WRITELOST = 3'd2, WRITEAFTELLOST = 3'd3, READ = 3'd4;
	
	reg [2:0] ps,ns;
	reg [1:0]counter2bR,counter2bW;
	
	always@(posedge clk)
		ps <= ns;
	
	always@(negedge clk)begin
		if(~rst)begin
			ns <= IDLE;
			counter2bR <= 2'b00;
			counter2bW <= 2'b00;
			DM_WE <= 1'b0;
			cache_we_word <= 1'b0;
			WritebackSignal <= 1'b0;
			WriteData_Buffer <= 1'b0;
			cache_we_block <= 1'b0;
			CacheLdFromBuffer <= 1'b0;
			cache_dataReady <= 1'b0;
		end
		else begin
			case(ps)
				IDLE:begin
					cache_we_block <= 1'b0;
					CacheLdFromBuffer <= 1'b0;
					DM_WE <= 1'b0;
					cache_we_word <= 1'b0;
					cache_dataReady <= 1'b0;
					if(memtoreg & hit)begin					
						cache_dataReady <= 1'b1;
						ns <= IDLE;
					end
					else if(memtoreg & ~hit)begin
						WritebackSignal = 1'b1;
						ns <= READLOST;
					end
					else if(memwrite & hit)begin
						cache_we_word <= 1'b1;
						ns <= IDLE;
					end
					else if(memwrite & ~hit)begin
						ns <= WRITELOST;
						WriteData_Buffer <= 1'b1;
						WritebackSignal <= 1'b1;
					end
					else
						ns <= IDLE;
				end
				// READ:begin
					// cache_dataReady <= 1'b1;
					// ns <= IDLE;
				// end
				READLOST:begin
					WritebackSignal = 1'b0;
					if(counter2bR == 2'd2)begin
						counter2bR <= 2'd0;
						cache_we_block <= 1'b1;
						cache_dataReady <= 1'b1;
						if(dirty)
							DM_WE <= 1'b1;
						ns <= IDLE;
					end
					else begin
						counter2bR <= counter2bR + 2'd1;
						ns <= READLOST;
					end
				end
				WRITELOST:begin
					WritebackSignal = 1'b0;
					WriteData_Buffer <= 1'b0;
					if(counter2bW == 2'd2)begin
						counter2bW <= 2'd0;
						cache_we_block <= 1'b1;
						if(dirty)
							DM_WE <= 1'b1;
						ns <= WRITEAFTELLOST;
					end
					else begin
						counter2bW <= counter2bW + 2'd1;
						ns <= WRITELOST;
					end
				end
				WRITEAFTELLOST:begin
					cache_we_block <= 1'b0;
					DM_WE <= 1'b0;
					cache_we_word <= 1'b1;
					CacheLdFromBuffer <= 1'b1;
					ns <= IDLE;
				end
				default:begin
					ns <= IDLE;
				end
			endcase
		end
	end
endmodule
