module Hazard_Unit(RsE1,RtE1,RsE2,RtE2,RsE3,RtE3,RsE4,RtE4,
                    RegWriteW1,RegWriteW2,MemtoRegW3,WriteRegW1,WriteRegW2,WriteRegW3,PCSrcE1,PCSrcE2,FlushE,
					FwdtoRsE1,FwdtoRtE1,FwdtoRsE2,FwdtoRtE2,FwdtoRsE3,FwdtoRtE3,FwdtoRsE4,FwdtoRtE4);
  input RegWriteW1,RegWriteW2,PCSrcE1,PCSrcE2,MemtoRegW3;
  input [4:0] RsE1,RtE1,RsE2,RtE2,RsE3,RtE3,RsE4,RtE4,WriteRegW1,WriteRegW2,WriteRegW3;
  output FlushE;
  output [1:0] FwdtoRsE1,FwdtoRtE1,FwdtoRsE2,FwdtoRtE2,FwdtoRsE3,FwdtoRtE3,FwdtoRsE4,FwdtoRtE4;
  
  wire fwd1toRsE1,fwd1toRtE1,fwd2toRsE1,fwd2toRtE1,fwd3toRsE1,fwd3toRtE1,fwd1toRsE2,
		fwd1toRtE2,fwd2toRsE2,fwd2toRtE2,fwd3toRsE2,fwd3toRtE2,fwd1toRsE3,fwd1toRtE3,fwd2toRsE3,
		fwd2toRtE3,fwd3toRsE3,fwd3toRtE3,fwd1toRsE4,fwd1toRtE4,fwd2toRsE4,fwd2toRtE4,fwd3toRsE4,fwd3toRtE4;
  
  assign fwd1toRsE1 = (RsE1 != 5'b0) & RegWriteW1 & (RsE1 == WriteRegW1);
  assign fwd1toRtE1 = (RtE1 != 5'b0) & RegWriteW1 & (RtE1 == WriteRegW1);
  assign fwd2toRsE1 = (RsE1 != 5'b0) & RegWriteW2 & (RsE1 == WriteRegW2);
  assign fwd2toRtE1 = (RtE1 != 5'b0) & RegWriteW2 & (RtE1 == WriteRegW2);
  assign fwd3toRsE1 = (RsE1 != 5'b0) & MemtoRegW3 & (RsE1 == WriteRegW3);
  assign fwd3toRtE1 = (RtE1 != 5'b0) & MemtoRegW3 & (RtE1 == WriteRegW3);
  
  assign FwdtoRsE1 =  ({fwd1toRsE1,fwd2toRsE1,fwd3toRsE1} == 3'b100)? 2'd1:
				({fwd1toRsE1,fwd2toRsE1,fwd3toRsE1} == 3'b010)?2'd2:
				({fwd1toRsE1,fwd2toRsE1,fwd3toRsE1} == 3'b001)?2'd3:2'd0;
  assign FwdtoRtE1 =  ({fwd1toRtE1,fwd2toRtE1,fwd3toRtE1} == 3'b100)? 2'd1:
				({fwd1toRtE1,fwd2toRtE1,fwd3toRtE1} == 3'b010)?2'd2:
				({fwd1toRtE1,fwd2toRtE1,fwd3toRtE1} == 3'b001)?2'd3:2'd0;
  
  assign fwd1toRsE2 = (RsE2 != 5'b0) & RegWriteW1 & (RsE2 == WriteRegW1);
  assign fwd1toRtE2 = (RtE2 != 5'b0) & RegWriteW1 & (RtE2 == WriteRegW1);
  assign fwd2toRsE2 = (RsE2 != 5'b0) & RegWriteW2 & (RsE2 == WriteRegW2);
  assign fwd2toRtE2 = (RtE2 != 5'b0) & RegWriteW2 & (RtE2 == WriteRegW2);
  assign fwd3toRsE2 = (RsE2 != 5'b0) & MemtoRegW3 & (RsE2 == WriteRegW3);
  assign fwd3toRtE2 = (RtE2 != 5'b0) & MemtoRegW3 & (RtE2 == WriteRegW3);
  
  assign FwdtoRsE2 =  ({fwd1toRsE2,fwd2toRsE2,fwd3toRsE2} == 3'b100)? 2'd1:
				({fwd1toRsE2,fwd2toRsE2,fwd3toRsE2} == 3'b010)?2'd2:
				({fwd1toRsE2,fwd2toRsE2,fwd3toRsE2} == 3'b001)?2'd3:2'd0;
  assign FwdtoRtE2 =  ({fwd1toRtE2,fwd2toRtE2,fwd3toRtE2} == 3'b100)? 2'd1:
				({fwd1toRtE2,fwd2toRtE2,fwd3toRtE2} == 3'b010)?2'd2:
				({fwd1toRtE2,fwd2toRtE2,fwd3toRtE2} == 3'b001)?2'd3:2'd0;
  
  assign fwd1toRsE3 = (RsE3 != 5'b0) & RegWriteW1 & (RsE3 == WriteRegW1);
  assign fwd1toRtE3 = (RtE3 != 5'b0) & RegWriteW1 & (RtE3 == WriteRegW1);
  assign fwd2toRsE3 = (RsE3 != 5'b0) & RegWriteW2 & (RsE3 == WriteRegW2);
  assign fwd2toRtE3 = (RtE3 != 5'b0) & RegWriteW2 & (RtE3 == WriteRegW2);
  assign fwd3toRsE3 = (RsE3 != 5'b0) & MemtoRegW3 & (RsE3 == WriteRegW3);
  assign fwd3toRtE3 = (RtE3 != 5'b0) & MemtoRegW3 & (RtE3 == WriteRegW3);
  
  assign FwdtoRsE3 =  ({fwd1toRsE3,fwd2toRsE3,fwd3toRsE3} == 3'b100)? 2'd1:
				({fwd1toRsE3,fwd2toRsE3,fwd3toRsE3} == 3'b010)?2'd2:
				({fwd1toRsE3,fwd2toRsE3,fwd3toRsE3} == 3'b001)?2'd3:2'd0;
  assign FwdtoRtE3 =  ({fwd1toRtE3,fwd2toRtE3,fwd3toRtE3} == 3'b100)? 2'd1:
				({fwd1toRtE3,fwd2toRtE3,fwd3toRtE3} == 3'b010)?2'd2:
				({fwd1toRtE3,fwd2toRtE3,fwd3toRtE3} == 3'b001)?2'd3:2'd0;
  
  assign fwd1toRsE4 = (RsE4 != 5'b0) & RegWriteW1 & (RsE4 == WriteRegW1);
  assign fwd1toRtE4 = (RtE4 != 5'b0) & RegWriteW1 & (RtE4 == WriteRegW1);
  assign fwd2toRsE4 = (RsE4 != 5'b0) & RegWriteW2 & (RsE4 == WriteRegW2);
  assign fwd2toRtE4 = (RtE4 != 5'b0) & RegWriteW2 & (RtE4 == WriteRegW2);
  assign fwd3toRsE4 = (RsE4 != 5'b0) & MemtoRegW3 & (RsE4 == WriteRegW3);
  assign fwd3toRtE4 = (RtE4 != 5'b0) & MemtoRegW3 & (RtE4 == WriteRegW3);
  
  assign FwdtoRsE4 =  ({fwd1toRsE4,fwd2toRsE4,fwd3toRsE4} == 3'b100)? 2'd1:
				({fwd1toRsE4,fwd2toRsE4,fwd3toRsE4} == 3'b010)?2'd2:
				({fwd1toRsE4,fwd2toRsE4,fwd3toRsE4} == 3'b001)?2'd3:2'd0;
  assign FwdtoRtE4 =  ({fwd1toRtE4,fwd2toRtE4,fwd3toRtE4} == 3'b100)? 2'd1:
				({fwd1toRtE4,fwd2toRtE4,fwd3toRtE4} == 3'b010)?2'd2:
				({fwd1toRtE4,fwd2toRtE4,fwd3toRtE4} == 3'b001)?2'd3:2'd0;

  assign FlushE = PCSrcE1 | PCSrcE2;
endmodule