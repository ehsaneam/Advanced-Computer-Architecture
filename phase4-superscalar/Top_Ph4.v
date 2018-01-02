module Top_ph4(input CLK , CLR);
  
  //////////////////////////////////////// Parameters ////////////////////////////////////////
  
  parameter WIDTH = 32;
  
  /////////////////////////////////// Wires : Hazard Unit ////////////////////////////////////
  
  wire FlushE_vaD;
  wire [1:0] FwdtoRs1E,FwdtoRt1E,FwdtoRs2E,FwdtoRt2E,FwdtoRs3E,FwdtoRt3E,FwdtoRs4E,FwdtoRt4E;
  
  //////////////////////////////////// Wires : STAGE F ///////////////////////////////////////
  
  wire [WIDTH-1:0] PC,NextPCF,RD1F,RD2F,RD3F,RD4F,Instr1outF,Instr2outF,Instr3outF,Instr4outF,Branch_plusXF,PCADDF,PCBranch_plusXF;
  reg [WIDTH-1:0] PCF;
  wire [9:0]signals1outF,signals2outF;
  wire signals3outF,signals4outF,UnderBranch1F,UnderBranch2F,UnderBranch3F,UnderBranch4F;
  
  //////////////////////////////////// wires : STAGE D ///////////////////////////////////////
  
  wire [WIDTH-1:0] RD1,RD2,RD3,RD4,RD5,RD6,RD7,RD8,SignImm1D,SignImm2D,SignImm3D,SignImm4D,WD1,WD2;
  reg [WIDTH-1:0] Instr1D,Instr2D,Instr3D,Instr4D,PCBranch_plusXD;
  wire [4:0] Rs1D,Rt1D,Rd1D,Rs2D,Rt2D,Rd2D,Rs3D,Rt3D,Rd3D,Rs4D,Rt4D,Rd4D,Aw1,Aw2;
  wire [3:0] ALUControl1D,ALUControl2D;
  reg [9:0] signals1outD,signals2outD;
  reg signals3outD,signals4outD,UnderBranch1D,UnderBranch2D,UnderBranch3D,UnderBranch4D;
  wire ALUSrc1D, RegDst1D, RegWrite1D,Branch1D,BNE1D,Extend1D,ALUSrc2D, RegDst2D, RegWrite2D,Branch2D,BNE2D,Extend2D,
		MemtoReg_3D,MemWrite4D,WE1,WE2;

  //////////////////////////////////// wires : STAGE E ///////////////////////////////////////
  
  reg [WIDTH-1:0] RD1E,RD2E,RD3E,RD4E,RD5E,RD6E,RD7E,RD8E,SignImm1E,SignImm2E,SignImm3E,SignImm4E,PCBranch_plusXE;
  wire [WIDTH-1:0] SrcA1E, SrcB1E,ALUOut1E,WriteData1E,PCBranch1E,SrcA2E, SrcB2E,ALUOut2E,WriteData2E,PCBranch2E,
					SrcA3E, SrcB3E,AGOut3E,WriteData4E,SrcA4E, SrcB4E,AGOut4E;
  reg [4:0] Rs1E,Rt1E,Rd1E,Rs2E,Rt2E,Rd2E,Rs3E,Rt3E,Rd3E,Rs4E,Rt4E,Rd4E;
  wire [4:0] WriteReg1E,WriteReg2E,WriteReg_3E;
  reg [3:0] ALUControl1E,ALUControl2E;
  wire PCSrc1E,PCSrc2E,Zero1E,Zero2E;
  reg RegWrite1E,RegWrite2E,MemtoReg_3E,MemWrite4E,RegDst1E,RegDst2E,ALUSrc1E,ALUSrc2E,Branch1E,Branch2E,BNE1E,BNE2E,
		UnderBranch1E,UnderBranch2E,UnderBranch3E,UnderBranch4E;
  
  //////////////////////////////////// wires : STAGE M ///////////////////////////////////////
  
  reg [WIDTH-1:0] AGOut3M,AGOut4M,WriteData4M;
  wire [WIDTH-1:0] ReadData3M;
  reg [4:0] WriteReg_3M;
  reg MemtoReg_3M,MemWrite4M;
  
  //////////////////////////////////// wires : STAGE W ///////////////////////////////////////
  
  reg [WIDTH-1:0] Result1W,Result2W,Result3W;
  reg [4:0] WriteReg1W,WriteReg2W,WriteReg_3W;
  reg RegWrite1W,RegWrite2W,MemtoReg_3W;
    
  /////////////////////////////////////// Always Block ///////////////////////////////////////
  
  always@(posedge CLK) begin
  
  //////////////////////////////////// Reseting : STAGE F ////////////////////////////////////
    
    if( ~CLR )begin
      PCF <= 32'b0;
      
  //////////////////////////////////// Reseting : STAGE D ////////////////////////////////////
  
      Instr1D <= 32'b0;
	  Instr2D <= 32'b0;
	  Instr3D <= 32'b0;
	  Instr4D <= 32'b0;
      PCBranch_plusXD <= 32'b0;
	  signals1outD <= 10'b0;
	  signals2outD <= 10'b0;
	  signals3outD <= 1'b0;
	  signals4outD <= 1'b0;
	  UnderBranch1D <= 1'b0;
	  UnderBranch2D <= 1'b0;
	  UnderBranch3D <= 1'b0;
	  UnderBranch4D <= 1'b0;
    
  //////////////////////////////////// Reseting : STAGE E ////////////////////////////////////
  
	  ALUControl1E <= 4'b0;
	  ALUControl2E <= 4'b0;
	  Rs1E <= 5'b0;
	  Rt1E <= 5'b0;
	  Rd1E <= 5'b0;
	  Rs2E <= 5'b0;
	  Rt2E <= 5'b0;
	  Rd2E <= 5'b0;
	  Rs3E <= 5'b0;
	  Rt3E <= 5'b0;
	  Rd3E <= 5'b0;
	  Rs4E <= 5'b0;
	  Rt4E <= 5'b0;
	  Rd4E <= 5'b0;
	  RD1E <= 32'b0;
	  RD2E <= 32'b0;
	  RD3E <= 32'b0;
	  RD4E <= 32'b0;
	  RD5E <= 32'b0;
	  RD6E <= 32'b0;
	  RD7E <= 32'b0;
	  RD8E <= 32'b0;
	  SignImm1E <= 32'b0;
	  SignImm2E <= 32'b0;
	  SignImm3E <= 32'b0;
	  SignImm4E <= 32'b0;
	  PCBranch_plusXE <= 32'b0;
	  RegWrite1E <= 1'b0;
	  RegWrite2E <= 1'b0;
	  MemtoReg_3E <= 1'b0;
	  MemWrite4E <= 1'b0;
	  RegDst1E <= 1'b0;
	  RegDst2E <= 1'b0;
	  ALUSrc1E <= 1'b0;
	  ALUSrc2E <= 1'b0;
	  Branch1E <= 1'b0;
	  Branch2E <= 1'b0;
	  BNE1E <= 1'b0;
	  BNE2E <= 1'b0;
	  UnderBranch1E <= 1'b0;
	  UnderBranch2E <= 1'b0;
	  UnderBranch3E <= 1'b0;
	  UnderBranch4E <= 1'b0;
    
  //////////////////////////////////// Reseting : STAGE M ////////////////////////////////////
    
	  AGOut3M <= 32'b0;
	  AGOut4M <= 32'b0;
	  WriteData4M <= 32'b0;
	  WriteReg_3M <= 5'b0;
	  MemtoReg_3M <= 1'b0;
	  MemWrite4M <= 1'b0;
    
  //////////////////////////////////// Reseting : STAGE W ////////////////////////////////////
    
	  Result1W <= 32'b0;
	  Result2W <= 32'b0;
	  Result3W <= 32'b0;
	  WriteReg1W <= 5'b0;
	  WriteReg2W <= 5'b0;
	  WriteReg_3W <= 5'b0;
	  RegWrite1W <= 1'b0;
	  RegWrite2W <= 1'b0;
	  MemtoReg_3W <= 1'b0;
    end
      
  /////////////////////////////////// Assignment : STAGE F ///////////////////////////////////
    
    else begin
      PCF <= PC;
      
  /////////////////////////////////// Assignment : STAGE D ///////////////////////////////////

	  Instr1D <= Instr1outF;
	  Instr2D <= Instr2outF;
	  Instr3D <= Instr3outF;
	  Instr4D <= Instr4outF;
      PCBranch_plusXD <= PCBranch_plusXF;
	  signals1outD <= signals1outF;
	  signals2outD <= signals2outF;
	  signals3outD <= signals3outF;
	  signals4outD <= signals4outF;
	  UnderBranch1D <= UnderBranch1F;
	  UnderBranch2D <= UnderBranch2F;
	  UnderBranch3D <= UnderBranch2F;
	  UnderBranch4D <= UnderBranch2F;
    
  /////////////////////////////////// Assignment : STAGE E ///////////////////////////////////
	  
	  ALUControl1E <= ALUControl1D;
	  ALUControl2E <= ALUControl2D;
	  Rs1E <= Rs1D;
	  Rt1E <= Rt1D;
	  Rd1E <= Rd1D;
	  Rs2E <= Rs2D;
	  Rt2E <= Rt2D;
	  Rd2E <= Rd2D;
	  Rs3E <= Rs3D;
	  Rt3E <= Rt3D;
	  Rd3E <= Rd3D;
	  Rs4E <= Rs4D;
	  Rt4E <= Rt4D;
	  Rd4E <= Rd4D;
	  RD1E <= RD1;
	  RD2E <= RD2;
	  RD3E <= RD3;
	  RD4E <= RD4;
	  RD5E <= RD5;
	  RD6E <= RD6;
	  RD7E <= RD7;
	  RD8E <= RD8;
	  SignImm1E <= SignImm1D;
	  SignImm2E <= SignImm2D;
	  SignImm3E <= SignImm3D;
	  SignImm4E <= SignImm4D;
	  PCBranch_plusXE <= PCBranch_plusXD;
	  RegWrite1E <= RegWrite1D;
	  RegWrite2E <= RegWrite2D;
	  MemtoReg_3E <= MemtoReg_3D;
	  MemWrite4E <= MemWrite4D;
	  RegDst1E <= RegDst1D;
	  RegDst2E <= RegDst2D;
	  ALUSrc1E <= ALUSrc1D;
	  ALUSrc2E <= ALUSrc2D;
	  Branch1E <= Branch1D;
	  Branch2E <= Branch2D;
	  BNE1E <= BNE1D;
	  BNE2E <= BNE2D;
	  UnderBranch1E <= UnderBranch1D;
	  UnderBranch2E <= UnderBranch2D;
	  UnderBranch3E <= UnderBranch3D;
	  UnderBranch4E <= UnderBranch4D;
  
  /////////////////////////////////// Assignment : STAGE M ///////////////////////////////////
  
	  AGOut3M <= AGOut3E;
	  AGOut4M <= AGOut4E;
	  WriteData4M <= WriteData4E;
	  WriteReg_3M <= WriteReg_3E;
	  MemtoReg_3M <= MemtoReg_3E;
	  MemWrite4M <= MemWrite4E;
	  if(UnderBranch4E & (PCSrc1E | PCSrc2E))
		MemWrite4M <= 1'b0;
	  if(UnderBranch3E & (PCSrc1E | PCSrc2E))
		MemtoReg_3M <= 1'b0;
  
  /////////////////////////////////// Assignment : STAGE W ///////////////////////////////////
	  
	  Result1W <= ALUOut1E;
	  Result2W <= ALUOut2E;
	  Result3W <= ReadData3M;
	  WriteReg1W <= WriteReg1E;
	  WriteReg2W <= WriteReg2E;
	  WriteReg_3W <= WriteReg_3M;
	  RegWrite1W <= RegWrite1E;
	  RegWrite2W <= RegWrite2E;
	  MemtoReg_3W <= MemtoReg_3M;
	  if(UnderBranch1E & (PCSrc1E | PCSrc2E))
		RegWrite1W <= 1'b0;
	  if(UnderBranch2E & (PCSrc1E | PCSrc2E))
		RegWrite2W <= 1'b0;
    end
    
    //////////////////////////////////// Flushing : STAGE E ////////////////////////////////////
    
    if(FlushE_vaD)begin
	  RegWrite1E <= 1'b0;
	  RegWrite2E <= 1'b0;
	  MemtoReg_3E <= 1'b0;
	  MemWrite4E <= 1'b0;
	  Branch1E <= 1'b0;
	  Branch2E <= 1'b0;
	  BNE1E <= 1'b0;
	  BNE2E <= 1'b0;
	  signals1outD <= 10'b0;
	  signals2outD <= 10'b0;
	  signals3outD <= 1'b0;
	  signals4outD <= 1'b0;
	  UnderBranch2D <= 1'b0;
	  UnderBranch3D <= 1'b0;
	  UnderBranch4D <= 1'b0;
    end
  end
  
  ///////////////////////////// Modules & Assigns : Hazard Unit //////////////////////////////
  
  Hazard_Unit hu(Rs1E,Rt1E,Rs2E,Rt2E,Rs3E,Rt3E,Rs4E,Rt4E,
                    RegWrite1W,RegWrite2W,MemtoReg_3W,WriteReg1W,WriteReg2W,WriteReg_3W,PCSrc1E,PCSrc2E,FlushE_vaD,
					FwdtoRs1E,FwdtoRt1E,FwdtoRs2E,FwdtoRt2E,FwdtoRs3E,FwdtoRt3E,FwdtoRs4E,FwdtoRt4E);
  
  /////////////////////////////// Modules & Assigns : STAGE F ////////////////////////////////
  
  Instruction_Memory im(PCF[7:2],RD1F,RD2F,RD3F,RD4F);
  pre_dicode pd(MemtoReg_3D,RD1F,RD2F,RD3F,RD4F,Rt3D,Instr1outF,Instr2outF,Instr3outF,Instr4outF,
				signals1outF,signals2outF,signals3outF,signals4outF,PCADDF,UnderBranch1F,UnderBranch2F,
				UnderBranch3F,UnderBranch4F,Branch_plusXF);
  assign NextPCF = PCADDF + PCF;
  assign PCBranch_plusXF = Branch_plusXF + PCF;
  assign PC = (PCSrc1E) ? PCBranch1E :(PCSrc2E) ? PCBranch2E: NextPCF;
  
  /////////////////////////////// Modules & Assigns : STAGE D ////////////////////////////////
  
  assign {ALUSrc1D,RegDst1D,RegWrite1D,Branch1D,BNE1D,Extend1D,ALUControl1D} = signals1outD;
  assign {ALUSrc2D,RegDst2D,RegWrite2D,Branch2D,BNE2D,Extend2D,ALUControl2D} = signals2outD;
  assign MemtoReg_3D = signals3outD;
  assign MemWrite4D = signals4outD;
  Register_File rf(CLK, WE1,WE2, Instr1D[25:21], Instr1D[20:16], Instr2D[25:21], Instr2D[20:16] ,
				Instr3D[25:21], Instr3D[20:16], Instr4D[25:21], Instr4D[20:16], Aw1 , Aw2, WD1,WD2,
               RD1, RD2,RD3, RD4,RD5, RD6,RD7, RD8 );
  assign WD1 = (RegWrite1W)? Result1W: Result2W;
  assign WD2 = (MemtoReg_3W)? Result3W: Result2W;
  assign Aw1 = (RegWrite1W)? WriteReg1W: WriteReg2W;
  assign Aw2 = (MemtoReg_3W)? WriteReg_3W: WriteReg2W;
  assign WE1 = (RegWrite1W)? 1'b1:RegWrite2W;
  assign WE2 = (MemtoReg_3W)? 1'b1:RegWrite2W;
  assign Rs1D = Instr1D[25:21];
  assign Rt1D = Instr1D[20:16];
  assign Rd1D = Instr1D[15:11];
  assign SignImm1D = (Extend1D)?{ {16{Instr1D[15]}},Instr1D[15:0] }: { 16'b0,Instr1D[15:0] };
  assign Rs2D = Instr2D[25:21];
  assign Rt2D = Instr2D[20:16];
  assign Rd2D = Instr2D[15:11];
  assign SignImm2D = (Extend2D)?{ {16{Instr2D[15]}},Instr2D[15:0] }: { 16'b0,Instr2D[15:0] };
  assign Rs3D = Instr3D[25:21];
  assign Rt3D = Instr3D[20:16];
  assign Rd3D = Instr3D[15:11];
  assign SignImm3D = {{16{Instr3D[15]}},Instr3D[15:0]};
  assign Rs4D = Instr4D[25:21];
  assign Rt4D = Instr4D[20:16];
  assign Rd4D = Instr4D[15:11];
  assign SignImm4D = {{16{Instr4D[15]}},Instr4D[15:0]};
  
  /////////////////////////////// Modules & Assigns : STAGE E ////////////////////////////////
  
  ALU alu1(SrcA1E, SrcB1E, ALUControl1E, ALUOut1E,Zero1E);
  ALU alu2(SrcA2E, SrcB2E, ALUControl2E, ALUOut2E,Zero2E);
  AG ag1(SrcA3E, SrcB3E,AGOut3E);
  AG ag2(SrcA4E, SrcB4E,AGOut4E);
  assign WriteReg1E = RegDst1E ? Rd1E : Rt1E;
  assign WriteReg2E = RegDst2E ? Rd2E : Rt2E;
  assign WriteReg_3E = Rt3E;
  assign PCSrc1E = Branch1E & (BNE1E ^ Zero1E);
  assign PCSrc2E = Branch2E & (BNE2E ^ Zero2E);
  assign SrcA1E = (FwdtoRs1E==2'b01) ? Result1W:
                  (FwdtoRs1E==2'b10) ? Result2W:
				  (FwdtoRs1E==2'b11) ? Result3W:RD1E;
  assign WriteData1E = (FwdtoRt1E==2'b01) ? Result1W:
                  (FwdtoRt1E==2'b10) ? Result2W:
				  (FwdtoRt1E==2'b11) ? Result3W:RD2E;
  assign SrcA2E = (FwdtoRs2E==2'b01) ? Result1W:
                  (FwdtoRs2E==2'b10) ? Result2W:
				  (FwdtoRs2E==2'b11) ? Result3W:RD3E;
  assign WriteData2E = (FwdtoRt2E==2'b01) ? Result1W:
                  (FwdtoRt2E==2'b10) ? Result2W:
				  (FwdtoRt2E==2'b11) ? Result3W:RD4E;
  assign SrcA3E = (FwdtoRs3E==2'b01) ? Result1W:
                  (FwdtoRs3E==2'b10) ? Result2W:
				  (FwdtoRs3E==2'b11) ? Result3W:RD5E;
  assign SrcA4E = (FwdtoRs4E==2'b01) ? Result1W:
                  (FwdtoRs4E==2'b10) ? Result2W:
				  (FwdtoRs4E==2'b11) ? Result3W:RD7E;
  assign WriteData4E = (FwdtoRt4E==2'b01) ? Result1W:
                  (FwdtoRt4E==2'b10) ? Result2W:
				  (FwdtoRt4E==2'b11) ? Result3W:RD8E;
  assign SrcB1E = ALUSrc1E ? SignImm1E : WriteData1E;
  assign SrcB2E = ALUSrc2E ? SignImm2E : WriteData2E;
  assign SrcB3E = SignImm3E;
  assign SrcB4E = SignImm4E;
  assign PCBranch1E = PCBranch_plusXE + (SignImm1E<<2);
  assign PCBranch2E = PCBranch_plusXE + (SignImm2E<<2);
    
  /////////////////////////////// Modules & Assigns : STAGE M ////////////////////////////////
  
  Data_Memory dm(CLK, MemWrite4M, AGOut3M,AGOut4M, WriteData4M, ReadData3M);

endmodule