module Top_ph3(input CLK , CLR);
  
  //////////////////////////////////////// Parameters ////////////////////////////////////////
  
  parameter WIDTH = 32;
  
  /////////////////////////////////// Wires : Hazard Unit ////////////////////////////////////
  
  wire [1:0] ForwardAE,ForwardBE;
  wire StallF,StallD,FlushE;
  
  //////////////////////////////////// Wires : STAGE F ///////////////////////////////////////
  
  wire [WIDTH-1:0] PC,PCPlus4F,RDF;
  reg [WIDTH-1:0] PCF;
  
  //////////////////////////////////// wires : STAGE D ///////////////////////////////////////
  
  wire [WIDTH-1:0] RD1D,RD2D,SignImmD;
  reg [WIDTH-1:0] InstrD,PCPlus4D;
  wire [4:0] RsD,RtD,RdD;
  wire [3:0] ALUControlD;
  wire MemtoRegD, MemWriteD,ALUSrcD, RegDstD, RegWriteD,BranchD,BNED,ExtendD;
  
  //////////////////////////////////// wires : STAGE E ///////////////////////////////////////
  
  reg [WIDTH-1:0] RD1E,RD2E,SignImmE,PCPlus4E;
  wire [WIDTH-1:0] SrcAE, SrcBE,ALUOutE,WriteDataE,PCBranchE;
  reg [4:0] RsE,RtE,RdE;
  wire [4:0] WriteRegE;
  reg [3:0] ALUControlE;
  wire PCSrcE,ZeroE;
  reg RegWriteE,MemtoRegE,MemWriteE,RegDstE,ALUSrcE,BranchE,BNEE;
  
  //////////////////////////////////// wires : STAGE M ///////////////////////////////////////
  
  reg [WIDTH-1:0] ALUOutM,WriteDataM;
  wire [WIDTH-1:0] ReadDataM;
  wire [4:0] cache_writeReg;
  reg [4:0] WriteRegM;
  reg RegWriteM,MemtoRegM,MemWriteM;
  wire hit,cache_dataReady;
  
  //////////////////////////////////// wires : STAGE W ///////////////////////////////////////
  
  wire [WIDTH-1:0] ResultW;
  reg [WIDTH-1:0] ReadDataW,ALUOutW;
  reg [4:0] WriteRegW;
  reg RegWriteW,MemtoRegW;
  
  /////////////////////////////////////// Always Block ///////////////////////////////////////
  
  always@(posedge CLK) begin
  
  //////////////////////////////////// Reseting : STAGE F ////////////////////////////////////
    
    if( ~CLR )begin
      PCF <= 32'b0;
      
  //////////////////////////////////// Reseting : STAGE D ////////////////////////////////////
  
      InstrD <= 32'b0;
      PCPlus4D <= 32'b0;
    
  //////////////////////////////////// Reseting : STAGE E ////////////////////////////////////
  
      RegWriteE <= 1'b0;
      BNEE <= 1'b0;
      MemtoRegE <= 1'b0;
      MemWriteE <= 1'b0;
      ALUSrcE <= 1'b0;
      RegDstE <= 1'b0;
      BranchE <= 1'b0;
      ALUControlE <= 4'b0;
      RD1E <= 32'b0;
      RD2E <= 32'b0;
      RsE <= 5'b0;
      RtE <= 5'b0;
      RdE <= 5'b0;
      SignImmE <= 32'b0;
      PCPlus4E <= 32'b0;
    
  //////////////////////////////////// Reseting : STAGE M ////////////////////////////////////
    
      RegWriteM <= 1'b0;
      MemtoRegM <= 1'b0;
      MemWriteM <= 1'b0;
      ALUOutM <= 32'b0;
      WriteDataM <= 32'b0;
      WriteRegM <= 5'b0;
    
  //////////////////////////////////// Reseting : STAGE W ////////////////////////////////////
    
      RegWriteW <= 1'b0;
      MemtoRegW <= 1'b0;
      ReadDataW <= 32'b0;
      ALUOutW <= 32'b0;
      WriteRegW <= 5'b0;
    end
      
  /////////////////////////////////// Assignment : STAGE F ///////////////////////////////////
    
    else begin
      if( ~StallF )
        PCF <= PC;
      
  /////////////////////////////////// Assignment : STAGE D ///////////////////////////////////
  
      if( ~StallD )begin
        InstrD <= RDF;
        PCPlus4D <= PCPlus4F;
      end
    
  /////////////////////////////////// Assignment : STAGE E ///////////////////////////////////
  
      RegWriteE <= RegWriteD;
      BNEE <= BNED;
      MemtoRegE <= MemtoRegD;
      MemWriteE <= MemWriteD;
      ALUSrcE <= ALUSrcD;
      RegDstE <= RegDstD;
      BranchE <= BranchD;
      ALUControlE <= ALUControlD;
      RD1E <= RD1D;
      RD2E <= RD2D;
      RsE <= RsD;
      RtE <= RtD;
      RdE <= RdD;
      SignImmE <= SignImmD;
      PCPlus4E <= PCPlus4D;
  
  /////////////////////////////////// Assignment : STAGE M ///////////////////////////////////
  
      RegWriteM <= RegWriteE;
      MemtoRegM <= MemtoRegE;
      MemWriteM <= MemWriteE;
      ALUOutM <= ALUOutE;
      WriteDataM <= WriteDataE;
      WriteRegM <= WriteRegE;
  
  /////////////////////////////////// Assignment : STAGE W ///////////////////////////////////
  
      RegWriteW <= RegWriteM | cache_dataReady;
      MemtoRegW <= cache_dataReady;
      ReadDataW <= ReadDataM;
      ALUOutW <= ALUOutM;
      WriteRegW <= (cache_dataReady)?cache_writeReg:WriteRegM;
    end
    
    //////////////////////////////////// Flushing : STAGE E ////////////////////////////////////
    
    if(FlushE)begin
      RegWriteE <= 1'b0;
      BNEE <= 1'b0;
      MemtoRegE <= 1'b0;
      MemWriteE <= 1'b0;
      ALUSrcE <= 1'b0;
      RegDstE <= 1'b0;
      BranchE <= 1'b0;
      ALUControlE <= 4'b0;
      RD1E <= 32'b0;
      RD2E <= 32'b0;
      RsE <= 5'b0;
      RtE <= 5'b0;
      RdE <= 5'b0;
      SignImmE <= 32'b0;
      PCPlus4E <= 32'b0;
    end
  end
  
  ///////////////////////////// Modules & Assigns : Hazard Unit //////////////////////////////
  
  Hazard_Unit hu(CLK,CLR,hit,RsD,RtD,RsE,RtE,MemWriteD,MemWriteM,MemtoRegD,MemtoRegE,MemtoRegM,WriteRegM,RegWriteM,
                    RegWriteW,WriteRegW,PCSrcE,StallF,StallD,FlushE,ForwardAE,ForwardBE);

  /////////////////////////////// Modules & Assigns : STAGE F ////////////////////////////////
  
  Instruction_Memory im(PCF[7:2],RDF);
  assign PCPlus4F = 32'd4 + PCF;
  assign PC = PCSrcE ? PCBranchE : PCPlus4F;
  
  /////////////////////////////// Modules & Assigns : STAGE D ////////////////////////////////
  
  Register_File rf(CLK,RegWriteW,InstrD[25:21], InstrD[20:16], WriteRegW, ResultW,RD1D,RD2D);
  Control_Unit cu(InstrD[31:26], InstrD[5:0],MemtoRegD, MemWriteD,ALUSrcD, RegDstD, RegWriteD,BranchD,
                  BNED,ExtendD,ALUControlD);
  assign RsD = InstrD[25:21];
  assign RtD = InstrD[20:16];
  assign RdD = InstrD[15:11];
  assign SignImmD = (ExtendD)?{ {16{InstrD[15]}},InstrD[15:0] }: { 16'b0,InstrD[15:0] };
  
  /////////////////////////////// Modules & Assigns : STAGE E ////////////////////////////////
  
  ALU alu(SrcAE, SrcBE, ALUControlE, ALUOutE,ZeroE);
  assign WriteRegE = RegDstE ? RdE : RtE;
  assign PCSrcE = BranchE & (BNEE ^ ZeroE);
  assign SrcAE = (ForwardAE==2'b00) ? RD1E:
                 (ForwardAE==2'b01) ? ResultW:
                 (ForwardAE==2'b10) ? ALUOutM:32'b0;
  assign WriteDataE = (ForwardBE==2'b00) ? RD2E:
                 (ForwardBE==2'b01) ? ResultW:
                 (ForwardBE==2'b10) ? ALUOutM:32'b0;
  assign SrcBE = ALUSrcE ? SignImmE : WriteDataE;
  assign PCBranchE = PCPlus4E + (SignImmE<<2);
    
  /////////////////////////////// Modules & Assigns : STAGE M ////////////////////////////////
  
  cache_top ct(CLK , CLR,WriteRegM, MemtoRegM , MemWriteM , ALUOutM , WriteDataM , hit , ReadDataM ,cache_dataReady, cache_writeReg);
  
  /////////////////////////////// Modules & Assigns : STAGE W ////////////////////////////////
  
  assign ResultW = MemtoRegW ? ReadDataW : ALUOutW;
endmodule