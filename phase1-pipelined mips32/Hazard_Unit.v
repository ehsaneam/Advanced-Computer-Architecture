module Hazard_Unit(CLK,CLR,RsD,RtD,RsE,RtE,MemtoRegE,WriteRegM,RegWriteM,
                    RegWriteW,WriteRegW,PCSrcE,StallF,StallD,FlushE,ForwardAE,ForwardBE);
  input MemtoRegE,RegWriteM,RegWriteW,PCSrcE,CLK,CLR;
  input [4:0] RsD,RtD,RsE,RtE,WriteRegM,WriteRegW;
  output StallF,StallD,FlushE;
  output [1:0] ForwardAE,ForwardBE;
  
  wire A1_forwardMtoE,A2_forwardMtoE,A1_forwardWtoE,A2_forwardWtoE,lwstall;
  reg PCSrc_Reg;

  always@(posedge CLK)begin
    if( ~CLR )
      PCSrc_Reg <= 1'b0;
    else
      PCSrc_Reg <= PCSrcE;
  end
  
  assign A1_forwardMtoE = (RsE != 5'b0) & RegWriteM & (RsE == WriteRegM);
  assign A2_forwardMtoE = (RtE != 5'b0) & RegWriteM & (RtE == WriteRegM);
  
  assign A1_forwardWtoE = (RsE != 5'b0) & RegWriteW & (RsE == WriteRegW);
  assign A2_forwardWtoE = (RtE != 5'b0) & RegWriteW & (RtE == WriteRegW);
  
  assign ForwardAE = ({A1_forwardMtoE,A1_forwardWtoE} == 2'b11)? 2'b10:{A1_forwardMtoE,A1_forwardWtoE};
  assign ForwardBE = ({A2_forwardMtoE,A2_forwardWtoE} == 2'b11)? 2'b10:{A2_forwardMtoE,A2_forwardWtoE};
  
  assign lwstall = ((RsD == RtE) | (RtD == RtE)) & MemtoRegE;
  assign StallF = lwstall;
  assign StallD = lwstall;
  assign FlushE = PCSrcE | lwstall | PCSrc_Reg;
endmodule