module pre_dicode(prv_ld,Instr1,Instr2,Instr3,Instr4,RtD3,Instr1out,Instr2out,Instr3out,Instr4out,
				signals1out,signals2out,signals3out,signals4out,PCADD,UnderBranch1,UnderBranch2,UnderBranch3,UnderBranch4,Branch_plusX);
	input prv_ld;
	input [4:0] RtD3;
	input [31:0] Instr1,Instr2,Instr3,Instr4;
	output [31:0] Instr1out,Instr2out,Instr3out,Instr4out,PCADD,Branch_plusX;
	output [9:0] signals1out,signals2out;
	output signals3out,signals4out,UnderBranch1,UnderBranch2,UnderBranch3,UnderBranch4;
	
	wire MemtoReg1, MemWrite1,ALUSrc1, RegDst1, RegWrite1,Branch1,BNE1,Extnd1;
	wire [3:0] ALUControl1;
	wire MemtoReg2, MemWrite2,ALUSrc2, RegDst2, RegWrite2,Branch2,BNE2,Extnd2;
	wire [3:0] ALUControl2;
	wire MemtoReg_3, MemWrite3,ALUSrc3, RegDst3, RegWrite3,Branch3,BNE3,Extnd3;
	wire [3:0] ALUControl3;
	wire MemtoReg4, MemWrite4,ALUSrc4, RegDst4, RegWrite4,Branch4,BNE4,Extnd4;
	wire [3:0] ALUControl4;
	wire [11:0] signals1,signals2,signals3,signals4;
	wire stall2,stall3,stall4,dpn_stall1,dpn_stall2,dpn_stall3,dpn_stall4;
	wire [1:0] place1,place2,place3,place4;
	wire UB2,UB3,UB4,zero_zero1,zero_zero2,zero_zero3,zero_zero4;
	
	assign signals1 = {MemtoReg1,MemWrite1,ALUSrc1,RegDst1,RegWrite1,Branch1,BNE1,Extnd1,ALUControl1};
	assign signals2 = {MemtoReg2,MemWrite2,ALUSrc2,RegDst2,RegWrite2,Branch2,BNE2,Extnd2,ALUControl2};
	assign signals3 = {MemtoReg_3,MemWrite3,ALUSrc3,RegDst3,RegWrite3,Branch3,BNE3,Extnd3,ALUControl3};
	assign signals4 = {MemtoReg4,MemWrite4,ALUSrc4,RegDst4,RegWrite4,Branch4,BNE4,Extnd4,ALUControl4};
	
	Control_Unit cu1(Instr1[31:26],Instr1[5:0],MemtoReg1,MemWrite1,ALUSrc1,RegDst1,RegWrite1,Branch1,BNE1,Extnd1,ALUControl1);
	Control_Unit cu2(Instr2[31:26],Instr2[5:0],MemtoReg2,MemWrite2,ALUSrc2,RegDst2,RegWrite2,Branch2,BNE2,Extnd2,ALUControl2);
	Control_Unit cu3(Instr3[31:26],Instr3[5:0],MemtoReg_3,MemWrite3,ALUSrc3,RegDst3,RegWrite3,Branch3,BNE3,Extnd3,ALUControl3);
	Control_Unit cu4(Instr4[31:26],Instr4[5:0],MemtoReg4,MemWrite4,ALUSrc4,RegDst4,RegWrite4,Branch4,BNE4,Extnd4,ALUControl4);
	
	fu_wb_check check1(prv_ld,MemtoReg1,MemtoReg2,MemtoReg_3,MemtoReg4,RegWrite1,RegWrite2,RegWrite3,RegWrite4,
					MemWrite1,MemWrite2,MemWrite3,MemWrite4,Branch1,Branch2,Branch3,Branch4,
					stall2,stall3,stall4,place1,place2,place3,place4,UB2,UB3,UB4,Branch_plusX);
					
	dependancy_check check2(prv_ld,Instr1[25:21],Instr2[25:21],Instr3[25:21],Instr4[25:21],Instr1[20:16],Instr2[20:16],
						Instr3[20:16],Instr4[20:16],Instr1[15:11],Instr2[15:11],Instr3[15:11],RtD3,Branch1,Branch2,Branch3,Branch4,
						RegDst1,RegDst2,RegDst3,dpn_stall1,dpn_stall2,dpn_stall3,dpn_stall4,zero_zero1,zero_zero2,zero_zero3,zero_zero4);
						
	arrange ar(Instr1,Instr2,Instr3,Instr4,dpn_stall1,stall2 | dpn_stall2,stall3 | dpn_stall3,stall4 | dpn_stall4,
				place1,place2,place3,place4,signals1,signals2,signals3,signals4,UB2,UB3,UB4,
				zero_zero1,zero_zero2,zero_zero3,zero_zero4,
				Instr1out,Instr2out,Instr3out,Instr4out,signals1out,signals2out,signals3out,signals4out,PCADD,
				UnderBranch1,UnderBranch2,UnderBranch3,UnderBranch4);
endmodule

module arrange(Instr1,Instr2,Instr3,Instr4,stall1,stall2,stall3,stall4,place1,place2,place3,place4,signals1,signals2,signals3,signals4,
				UB2,UB3,UB4,zero_zero1,zero_zero2,zero_zero3,zero_zero4,Instr1out,Instr2out,Instr3out,Instr4out,
				signals1out,signals2out,signals3out,signals4out,PCADD,UnderBranch1,UnderBranch2,UnderBranch3,UnderBranch4);
	input [11:0] signals1,signals2,signals3,signals4;
	input [31:0] Instr1,Instr2,Instr3,Instr4;
	input stall1,stall2,stall3,stall4,UB2,UB3,UB4,zero_zero1,zero_zero2,zero_zero3,zero_zero4;
	input [1:0] place1,place2,place3,place4;
	output reg [31:0] Instr1out,Instr2out,Instr3out,Instr4out,PCADD;
	output reg [9:0] signals1out,signals2out;
	output reg signals3out,signals4out,UnderBranch1,UnderBranch2,UnderBranch3,UnderBranch4;
	
	always@(*)begin
		Instr1out <= 32'b0;
		Instr2out <= 32'b0;
		Instr3out <= 32'b0;
		Instr4out <= 32'b0;
		signals1out <= 12'b0;
		signals2out <= 12'b0;
		signals3out <= 12'b0;
		signals4out <= 12'b0;
		UnderBranch1 <= 1'b0;
		UnderBranch2 <= 1'b0;
		UnderBranch3 <= 1'b0;
		UnderBranch4 <= 1'b0;
		if(stall1)
			PCADD <= 32'd0;
		else if(zero_zero1)
			PCADD <= {{14{Instr1[15]}},Instr1[15:0],2'b00} + 32'd4;
		else if(stall2)
			PCADD <= 32'd4;
		else if(zero_zero2)
			PCADD <= {{14{Instr2[15]}},Instr2[15:0],2'b00} + 32'd8;
		else if(stall3)
			PCADD <= 32'd8;
		else if(zero_zero3)
			PCADD <= {{14{Instr3[15]}},Instr3[15:0],2'b00} + 32'd12;
		else if(stall4)
			PCADD <= 32'd12;
		else if(zero_zero4)
			PCADD <= {{14{Instr3[15]}},Instr3[15:0],2'b00} + 32'd16;
		else
			PCADD <= 32'd16;
		if(~stall1 & ~zero_zero1)begin
			case(place1)
				2'd0: begin Instr1out <= Instr1; signals1out <= signals1[9:0]; end
				2'd1: begin Instr2out <= Instr1; signals2out <= signals1[9:0]; end
				2'd2: begin Instr3out <= Instr1; signals3out <= signals1[11]; end
				2'd3: begin Instr4out <= Instr1; signals4out <= signals1[10]; end
			endcase
		end
		if(~stall2 & ~zero_zero2)begin
			case(place2)
				2'd0: begin Instr1out <= Instr2; signals1out <= signals2[9:0]; UnderBranch1 <= UB2; end
				2'd1: begin Instr2out <= Instr2; signals2out <= signals2[9:0]; UnderBranch2 <= UB2; end
				2'd2: begin Instr3out <= Instr2; signals3out <= signals2[11]; UnderBranch3 <= UB2; end
				2'd3: begin Instr4out <= Instr2; signals4out <= signals2[10]; UnderBranch4 <= UB2; end
			endcase
		end
		if(~stall3 & ~zero_zero3)begin
			case(place3)
				2'd0: begin Instr1out <= Instr3; signals1out <= signals3[9:0]; UnderBranch1 <= UB3; end
				2'd1: begin Instr2out <= Instr3; signals2out <= signals3[9:0]; UnderBranch2 <= UB3; end
				2'd2: begin Instr3out <= Instr3; signals3out <= signals3[11]; UnderBranch3 <= UB3; end
				2'd3: begin Instr4out <= Instr3; signals4out <= signals3[10]; UnderBranch4 <= UB3; end
			endcase
		end
		if(~stall4 & ~zero_zero4)begin
			case(place4)
				2'd0: begin Instr1out <= Instr4; signals1out <= signals3[9:0]; UnderBranch1 <= UB4; end
				2'd1: begin Instr2out <= Instr4; signals2out <= signals3[9:0]; UnderBranch2 <= UB4; end
				2'd2: begin Instr3out <= Instr4; signals3out <= signals3[11]; UnderBranch3 <= UB4; end
				2'd3: begin Instr4out <= Instr4; signals4out <= signals3[10]; UnderBranch4 <= UB4; end
			endcase
		end
	end
	
endmodule

module dependancy_check(prv_ld,Rs1,Rs2,Rs3,Rs4,Rt1,Rt2,Rt3,Rt4,Rd1,Rd2,Rd3,RtD3,Branch1,Branch2,Branch3,Branch4,RegDst1,RegDst2,RegDst3,
						dpn_stall1,dpn_stall2,dpn_stall3,dpn_stall4,zero_zero1,zero_zero2,zero_zero3,zero_zero4);
	input prv_ld,RegDst1,RegDst2,RegDst3,Branch1,Branch2,Branch3,Branch4;
	input [4:0] Rs1,Rs2,Rs3,Rs4,Rt1,Rt2,Rt3,Rt4,Rd1,Rd2,Rd3,RtD3;
	output reg dpn_stall1,dpn_stall2,dpn_stall3,dpn_stall4,zero_zero1,zero_zero2,zero_zero3,zero_zero4;
	
	wire [4:0] dest1,dest2,dest3;
	
	assign dest1 = (RegDst1)?Rd1:Rt1;
	assign dest2 = (RegDst2)?Rd2:Rt2;
	assign dest3 = (RegDst3)?Rd3:Rt3;
	
	always@(*)begin
		dpn_stall1 <= 1'b0;
		dpn_stall2 <= 1'b0;
		dpn_stall3 <= 1'b0;
		dpn_stall4 <= 1'b0;
		if( (((dest1 == Rs2)& (Rs2 != 5'b0)) | ((dest1 == Rt2)& (Rt2 != 5'b0))) & (dest1 != 5'b0) )begin
			dpn_stall2 <= 1'b1;
			dpn_stall3 <= 1'b1;
			dpn_stall4 <= 1'b1;
		end
		else if( (((dest1 == Rs3)& (Rs3 != 5'b0)) | ((dest1 == Rt3)& (Rt3 != 5'b0))) & (dest1 != 5'b0) )begin
			dpn_stall3 <= 1'b1;
			dpn_stall4 <= 1'b1;
		end
		else if( (((dest1 == Rs4)& (Rs4 != 5'b0)) | ((dest1 == Rt4)& (Rt4 != 5'b0))) & (dest1 != 5'b0) )
			dpn_stall4 <= 1'b1;
		if( (((dest2 == Rs3)& (Rs3 != 5'b0))  | ((dest2 == Rt3) & (Rt3 != 5'b0))) & (dest2 != 5'b0) )begin
			dpn_stall3 <= 1'b1;
			dpn_stall4 <= 1'b1;
		end
		else if( (((dest2 == Rs4)& (Rs4 != 5'b0)) | ((dest2 == Rt4) & (Rt4 != 5'b0))) & (dest2 != 5'b0) )
			dpn_stall4 <= 1'b1;
		if( (((dest3 == Rs4) & (Rs4 != 5'b0)) | ((dest3 == Rt4) & (Rt4 != 5'b0))) & (dest3 != 5'b0))
			dpn_stall4 <= 1'b1;
		if(prv_ld & (((RtD3 == Rs1)& (Rs1 != 5'b0)) | ((RtD3 == Rt1) & (Rt1 != 5'b0))) & (RtD3 != 5'b0))begin
			dpn_stall1 <= 1'b1;
			dpn_stall2 <= 1'b1;
			dpn_stall3 <= 1'b1;
			dpn_stall4 <= 1'b1;
		end
		else if(prv_ld & (((RtD3 == Rs2)& (Rs2 != 5'b0)) | ((RtD3 == Rt2)& (Rt2 != 5'b0))) & (RtD3 != 5'b0) )begin
			dpn_stall2 <= 1'b1;
			dpn_stall3 <= 1'b1;
			dpn_stall4 <= 1'b1;
		end
		else if(prv_ld & (((RtD3 == Rs3) & (Rs3 != 5'b0)) | ((RtD3 == Rt3)& (Rt3 != 5'b0))) & (RtD3 != 5'b0) )begin
			dpn_stall3 <= 1'b1;
			dpn_stall4 <= 1'b1;
		end
		else if(prv_ld & (((RtD3 == Rs3)& (Rs4 != 5'b0)) | ((RtD3 == Rt3) & (Rt4 != 5'b0))) & (RtD3 != 5'b0) )begin
			dpn_stall4 <= 1'b1;
		end
		zero_zero1 <= 1'b0;
		zero_zero2 <= 1'b0;
		zero_zero3 <= 1'b0;
		zero_zero4 <= 1'b0;
		if(Branch1 & (Rs1==Rt1))begin
			dpn_stall2 <= 1'b1;
			dpn_stall3 <= 1'b1;
			dpn_stall4 <= 1'b1;
			zero_zero1 <= 1'b1;
		end
		else if(Branch2 & (Rs2==Rt2))begin
			dpn_stall3 <= 1'b1;
			dpn_stall4 <= 1'b1;
			zero_zero2 <= 1'b1;
		end
		else if(Branch3 & (Rs3==Rt3))begin
			dpn_stall4 <= 1'b1;
			zero_zero3 <= 1'b1;
		end
		else if(Branch4 & (Rs4==Rt4))begin
			zero_zero4 <= 1'b1;
		end
	end

endmodule

module fu_wb_check(prv_ld,MemtoReg1,MemtoReg2,MemtoReg_3,MemtoReg4,RegWrite1,RegWrite2,RegWrite3,RegWrite4,
					MemWrite1,MemWrite2,MemWrite3,MemWrite4,Branch1,Branch2,Branch3,Branch4
					,stall2,stall3,stall4,place1,place2,place3,place4,UnderBranch2,UnderBranch3,UnderBranch4,Branch_plusX);
	input prv_ld,MemtoReg1,MemtoReg2,MemtoReg_3,MemtoReg4,RegWrite1,RegWrite2,RegWrite3,RegWrite4,
			MemWrite1,MemWrite2,MemWrite3,MemWrite4,Branch1,Branch2,Branch3,Branch4;
	output reg stall2,stall3,stall4,UnderBranch2,UnderBranch3,UnderBranch4;
	output reg [1:0] place1,place2,place3,place4;
	output [31:0] Branch_plusX;
	
	assign Branch_plusX = (UnderBranch2)?32'd4:(~UnderBranch2 & UnderBranch3)?32'd8:
							(~UnderBranch2 & ~UnderBranch3 & UnderBranch4)?32'd12:32'd0;
	
	always@(*)begin
		stall2 <= 1'b0;
		stall3 <= 1'b0;
		stall4 <= 1'b0;
		place1 <= 2'dx;
		place2 <= 2'dx;
		place3 <= 2'dx;
		place4 <= 2'dx;
		UnderBranch2 <= 1'b0;
		UnderBranch3 <= 1'b0;
		UnderBranch4 <= 1'b0;
		casez({MemtoReg1,MemtoReg2,MemtoReg_3,MemtoReg4})
			4'b0000:;
			4'b0001:
				place4 <= 2'd2;
			4'b0010:
				place3 <= 2'd2;
			4'b0011:begin
				place3 <= 2'd2;
				stall4 <= 1'b1;
			end
			4'b0100:
				place2 <= 2'd2;
			4'b0101:begin
				place2 <= 2'd2;
				stall4 <= 1'b1;
			end
			4'b011?:begin
				place2 <= 2'd2;
				stall3 <= 1'b1;
				stall4 <= 1'b1;
			end
			4'b1000:
				place1 <= 2'd2;
			4'b1001:begin
				place1 <= 2'd2;
				stall4 <= 1'b1;
			end
			4'b101?:begin
				place1 <= 2'd2;
				stall3 <= 1'b1;
				stall4 <= 1'b1;
			end
			4'b11??:begin
				place1 <= 2'd2;
				stall2 <= 1'b1;
				stall3 <= 1'b1;
				stall4 <= 1'b1;
			end
		endcase
		casez({MemWrite1,MemWrite2,MemWrite3,MemWrite4})
			4'b0000:;
			4'b0001:
				place4 <= 2'd3;
			4'b0010:
				place3 <= 2'd3;
			4'b0011:begin
				place3 <= 2'd3;
				stall4 <= 1'b1;
			end
			4'b0100:
				place2 <= 2'd3;
			4'b0101:begin
				place2 <= 2'd3;
				stall4 <= 1'b1;
			end
			4'b011?:begin
				place2 <= 2'd3;
				stall3 <= 1'b1;
				stall4 <= 1'b1;
			end
			4'b1000:
				place1 <= 2'd3;
			4'b1001:begin
				place1 <= 2'd3;
				stall4 <= 1'b1;
			end
			4'b101?:begin
				place1 <= 2'd3;
				stall3 <= 1'b1;
				stall4 <= 1'b1;
			end
			4'b11??:begin
				place1 <= 2'd3;
				stall2 <= 1'b1;
				stall3 <= 1'b1;
				stall4 <= 1'b1;
			end
		endcase
		casez({(~MemtoReg1 & RegWrite1) | Branch1,(~MemtoReg2 & RegWrite2) | Branch2,
				(~MemtoReg_3 & RegWrite3) | Branch3,(~MemtoReg4 & RegWrite4) | Branch4})
			4'b0000:;
			4'b0001:
				place4 <= 2'd0;
			4'b0010:
				place3 <= 2'd0;
			4'b0011:begin
				place3 <= 2'd0;
				if(Branch3 & Branch4)
					stall4 <= 1'b1;
				else
					place4 <= 2'd1;
			end
			4'b0100:
				place2 <= 2'd0;
			4'b0101:begin
				place2 <= 2'd0;
				if(Branch2 & Branch4)
					stall4 <= 1'b1;
				else
					place4 <= 2'd1;
			end
			4'b0110:begin
				place2 <= 2'd0;
				if(Branch3 & Branch2)begin
					stall3 <= 1'b1;
					stall4 <= 1'b1;
				end
				else
					place3 <= 2'd1;
			end
			4'b0111:begin
				place2 <= 2'd0;
				stall4 <= 1'b1;
				if(Branch3 & Branch2)
					stall3 <= 1'b1;
				else
					place3 <= 2'd1;
			end
			4'b1000:
				place1 <= 2'd0;
			4'b1001:begin
				place1 <= 2'd0;
				if(Branch1 & Branch4)
					stall4 <= 1'b1;
				else
					place4 <= 2'd1;
			end
			4'b1010:begin
				place1 <= 2'd0;
				if(Branch1 & Branch3)begin
					stall3 <= 1'b1;
					stall4 <= 1'b1;
				end
				else
					place3 <= 2'd1;
			end
			4'b1011:begin
				place1 <= 2'd0;
				stall4 <= 1'b1;
				if(Branch1 & Branch3)
					stall3 <= 1'b1;
				else
					place3 <= 2'd1;
			end
			4'b1100:begin
				place1 <= 2'd0;
				if(Branch1 & Branch2)begin
					stall2 <= 1'b1;
					stall3 <= 1'b1;
					stall4 <= 1'b1;
				end
				else
					place2 <= 2'd1;
			end
			4'b1101:begin
				place1 <= 2'd0;
				stall4 <= 1'b1;
				if(Branch1 & Branch2)begin
					stall2 <= 1'b1;
					stall3 <= 1'b1;
				end
				else
					place2 <= 2'd1;
			end
			4'b111?:begin
				place1 <= 2'd0;
				stall3 <= 1'b1;
				stall4 <= 1'b1;
				if(Branch1 & Branch2)
					stall2 <= 1'b1;
				else
					place2 <= 2'd1;
			end
		endcase
		casez({~MemtoReg1 & RegWrite1,~MemtoReg2 & RegWrite2,~MemtoReg_3 & RegWrite3,~MemtoReg4 & RegWrite4,prv_ld})
			5'b000??:;
			5'b0010?:;
			5'b00110:;
			5'b00111: stall4 <= 1'b1;
			5'b0100?:;
			5'b01010:;
			5'b01011: stall4 <= 1'b1;
			5'b01100:;
			5'b011?1: begin
				stall3 <= 1'b1;
				stall4 <= 1'b1;
			end
			5'b01110: stall4 <= 1'b1;
			5'b1000?:;
			5'b10010:;
			5'b10011: stall4 <= 1'b1;
			5'b10100:;
			5'b101?1: begin
				stall3 <= 1'b1;
				stall4 <= 1'b1;
			end
			5'b10110: stall4 <= 1'b1;
			5'b11000:;
			5'b11??1: begin
				stall2 <= 1'b1;
				stall3 <= 1'b1;
				stall4 <= 1'b1;
			end
			5'b11010: stall4 <= 1'b1;
			5'b111?0: begin
				stall3 <= 1'b1;
				stall4 <= 1'b1;
			end
		endcase
		casez({Branch1,Branch2,Branch3,Branch4})
			4'b1???:begin
				UnderBranch2 <= 1'b1;
				UnderBranch3 <= 1'b1;
				UnderBranch4 <= 1'b1;
			end
			4'b?1??:begin
				UnderBranch3 <= 1'b1;
				UnderBranch4 <= 1'b1;
			end
			4'b??1?:
				UnderBranch4 <= 1'b1;
		endcase
	end
endmodule