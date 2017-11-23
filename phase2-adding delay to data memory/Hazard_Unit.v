module Hazard_Unit(CLK,CLR,RsD,RtD,RsE,RtE,MemWriteD,BranchD,MemtoRegD,MemtoRegE,MemtoRegM,MemtoRegW,
                    RegWriteD,WriteRegM,RegWriteM,
                    RegWriteW,WriteRegW,PCSrcE,StallF,StallD,FlushE,ForwardAE,ForwardBE,
                    MemtoRegM_reg3,WriteRegM_reg3);

  input MemtoRegE,MemtoRegM,MemtoRegW,RegWriteM,RegWriteW,PCSrcE,CLK,CLR,RegWriteD,BranchD,MemtoRegD,MemWriteD;
  input [4:0] RsD,RtD,RsE,RtE,WriteRegM,WriteRegW;
  output StallF,StallD,FlushE;
  output reg MemtoRegM_reg3;
  output reg [4:0] WriteRegM_reg3;
  output [1:0] ForwardAE,ForwardBE;
  
  wire A1_forwardMtoE , A2_forwardMtoE , A1_forwardWtoE , A2_forwardWtoE , lwstall,lwstall_regs ,  lw_Br_stalls,
        lw_Br_stall1 , lw_Br_stall2 , lw_Br_stall3 , lw_MemOp_stalls , lw_MemOp_stall1  , lw_MemOp_stall2,
        lw_WBhazard_stall, lw_dependancy_stall1 , lw_dependancy_stall2 , lw_dependancy_stall3 , lw_dependancy_stall4
         , lw_dependancy_stalls;
  reg [4:0] WriteRegM_reg1,WriteRegM_reg2,lwstall_reg3;
  reg PCSrc_Reg,lwstall_reg1,lwstall_reg2,MemtoRegM_reg1,MemtoRegM_reg2;

  always@(posedge CLK)begin
    if( ~CLR ) begin
      PCSrc_Reg <= 1'b0;
      lwstall_reg1 <= 1'b0;
      lwstall_reg2 <= 1'b0;
      MemtoRegM_reg1 <= 1'b0;
      MemtoRegM_reg2 <= 1'b0;
      MemtoRegM_reg3 <= 1'b0;
      WriteRegM_reg1 <= 5'b0;
      WriteRegM_reg2 <= 5'b0;
      WriteRegM_reg3 <= 5'b0;
    end
    else begin
      PCSrc_Reg <= PCSrcE;
      lwstall_reg1 <= lw_dependancy_stall1;
      lwstall_reg2 <= lwstall_reg1 | lw_dependancy_stall2 | lw_Br_stall1;
      lwstall_reg3 <= lwstall_reg2 | lw_dependancy_stall3 | lw_MemOp_stall1 | lw_Br_stall2;
      MemtoRegM_reg1 <= MemtoRegM;
      MemtoRegM_reg2 <= MemtoRegM_reg1;
      MemtoRegM_reg3 <= MemtoRegM_reg2;
      WriteRegM_reg1 <= WriteRegM;
      WriteRegM_reg2 <= WriteRegM_reg1;
      WriteRegM_reg3 <= WriteRegM_reg2;
    end
  end
  /////////////////////////////////// Forwarding ////////////////////////////////////
  
  assign A1_forwardMtoE = ((RsE != 5'b0) & RegWriteM & (RsE == WriteRegM));
  assign A2_forwardMtoE = ((RtE != 5'b0) & RegWriteM & (RtE == WriteRegM));
  
  assign A1_forwardWtoE = (RsE != 5'b0) & RegWriteW & (RsE == WriteRegW);
  assign A2_forwardWtoE = (RtE != 5'b0) & RegWriteW & (RtE == WriteRegW);
  
  assign ForwardAE = ({A1_forwardMtoE,A1_forwardWtoE} == 2'b11)? 2'b10:{A1_forwardMtoE,A1_forwardWtoE};
  assign ForwardBE = ({A2_forwardMtoE,A2_forwardWtoE} == 2'b11)? 2'b10:{A2_forwardMtoE,A2_forwardWtoE};
  
  //////////////////////////////////// Stalling /////////////////////////////////////
  
  assign lw_dependancy_stall1 = ((RsD == RtE) | (RtD == RtE)) & MemtoRegE; // 1 stage distance - 4 stall
  assign lw_dependancy_stall2 = ((WriteRegM == RsD) | (WriteRegM == RtD)) & MemtoRegM; // 2 stage distance - 3 stall
  assign lw_dependancy_stall3 = ((WriteRegM_reg1 == RsD) | (WriteRegM_reg1 == RtD)) & MemtoRegM_reg1; // 2 stage distance + #1 clk memory - 2 stall
  assign lw_dependancy_stall4 = ((WriteRegM_reg2 == RsD) | (WriteRegM_reg2 == RtD)) & MemtoRegM_reg2; // 2 stage distance + #2 clk memory - 1 stall
  assign lw_dependancy_stalls = lw_dependancy_stall1 | lw_dependancy_stall2 | lw_dependancy_stall3 | lw_dependancy_stall4;
  
  assign lw_WBhazard_stall = RegWriteD & MemtoRegM_reg1;// 2 stage distance + #1 clk memory - 1 stall
  
  assign lw_MemOp_stall1 = MemtoRegE & ( MemtoRegD | MemWriteD );// 1 stage distance - 2 stall
  assign lw_MemOp_stall2 = MemtoRegM & ( MemtoRegD | MemWriteD );// 2 stage distance - 1 stall
  assign lw_MemOp_stalls = lw_MemOp_stall1 | lw_MemOp_stall2;
  
  assign lw_Br_stall1 = MemtoRegE & BranchD;// 1 stage distance - 3 stall
  assign lw_Br_stall2 = MemtoRegM & BranchD;// 2 stage distance - 2 stall
  assign lw_Br_stall3 = MemtoRegM_reg1 & BranchD;// 2 stage distance + #1 clk memory - 1 stall
  assign lw_Br_stalls = lw_Br_stall1 | lw_Br_stall2 | lw_Br_stall3;
  
  assign lwstall_regs = lwstall_reg1 | lwstall_reg2 | lwstall_reg3;
  
  assign lwstall = lwstall_regs | lw_Br_stalls | lw_MemOp_stalls | lw_dependancy_stalls | lw_WBhazard_stall;
  
  assign StallF = lwstall;
  assign StallD = lwstall;
  assign FlushE = PCSrcE | PCSrc_Reg | lwstall;
endmodule