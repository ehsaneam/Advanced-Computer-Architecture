module Hazard_Unit(CLK,CLR,hit,RsD,RtD,RsE,RtE,MemWriteD,MemWriteM,MemtoRegD,MemtoRegE,MemtoRegM,WriteRegM,RegWriteM,
                    RegWriteW,WriteRegW,PCSrcE,StallF,StallD,FlushE,ForwardAE,ForwardBE);
  input MemtoRegD,MemtoRegE,MemtoRegM,RegWriteM,RegWriteW,PCSrcE,CLK,CLR,hit,MemWriteD,MemWriteM;
  input [4:0] RsD,RtD,RsE,RtE,WriteRegM,WriteRegW;
  output StallF,StallD,FlushE;
  output [1:0] ForwardAE,ForwardBE;
  
  wire A1_forwardMtoE,A2_forwardMtoE,A1_forwardWtoE,A2_forwardWtoE,lwstall,nothitstall,lwstall2;
  reg PCSrc_Reg,lwstall_reg,cache_stall,WBstall;
  reg [2:0] counter5;
  reg [1:0] counter3;
  reg [4:0] WriteReg_buffer;

  always@(posedge CLK)begin
    if( ~CLR )begin
		PCSrc_Reg <= 1'b0;
		counter5 <= 3'd0;
		counter3 <= 2'd0;
		lwstall_reg <= 1'b0;
	end
    else begin
		PCSrc_Reg <= PCSrcE;
		lwstall_reg <= lwstall;
		WBstall <= 1'b0;
		if(counter3 > 0)
			counter3 = counter3-1;
		else if(lwstall2)
			counter3 <= 2'd2;
		if(MemtoRegM & ~hit)begin
			WBstall <= 1'b1;
			WriteReg_buffer <= WriteRegM;
		end
		if(counter5 > 0)
			counter5 <= counter5 - 1;
		else begin
			if((MemtoRegM | MemWriteM) & ~hit)
				counter5 <= 3'd5;
		end
	end
  end
  /////////////////////////////////////// forwarding /////////////////////////////////////////
  assign A1_forwardMtoE = (RsE != 5'b0) & RegWriteM & (RsE == WriteRegM);
  assign A2_forwardMtoE = (RtE != 5'b0) & RegWriteM & (RtE == WriteRegM);
  
  assign A1_forwardWtoE = (RsE != 5'b0) & RegWriteW & (RsE == WriteRegW);
  assign A2_forwardWtoE = (RtE != 5'b0) & RegWriteW & (RtE == WriteRegW);
  
  assign ForwardAE = ({A1_forwardMtoE,A1_forwardWtoE} == 2'b11)? 2'b10: {A1_forwardMtoE,A1_forwardWtoE};
  assign ForwardBE = ({A2_forwardMtoE,A2_forwardWtoE} == 2'b11)? 2'b10: {A2_forwardMtoE,A2_forwardWtoE};
  /////////////////////////////////////// stalling /////////////////////////////////////////
  assign nothitstall = (counter5>0) & (MemWriteD | MemtoRegD);
  assign lwstall = ((RsD == RtE) | (RtD == RtE)) & MemtoRegE;
  assign lwstall2 = (((RsD == WriteRegM) | (RtD == WriteRegM)) & (MemtoRegM & ~hit)) | (counter3>0);
  assign StallF = (nothitstall | lwstall2 | lwstall_reg | MemtoRegE | WBstall)&(~PCSrcE & ~PCSrc_Reg);
  assign StallD = (nothitstall | lwstall2 | lwstall_reg | MemtoRegE | WBstall)&(~PCSrcE & ~PCSrc_Reg);
  assign FlushE = PCSrcE | PCSrc_Reg | lwstall2 | nothitstall | lwstall_reg | MemtoRegE | WBstall;
endmodule