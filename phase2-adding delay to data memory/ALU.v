module ALU(input  [31:0] SrcAE, SrcBE, input  [3:0]  ALUControlE,
           output reg [31:0] ALUOutM,output ZeroE);
           
  wire signed[31:0] as,bs;
  
  assign as = SrcAE;
  assign bs = SrcBE;
  
  always @(*)
    case (ALUControlE)
      4'b0000: ALUOutM = SrcAE & SrcBE; // and
      4'b0001: ALUOutM = SrcAE << SrcBE; // sllv
      4'b0010: ALUOutM = SrcAE | SrcBE; // or
      4'b0011: ALUOutM = as >> bs; // srav
      4'b0100: ALUOutM = SrcAE + SrcBE; // add
      4'b0101: ALUOutM = SrcAE >> SrcBE ; // srlv
      4'b0110: ALUOutM = SrcAE ^ SrcBE; // xor
      4'b1000: ALUOutM = (SrcAE < SrcBE) ? 32'd1 : 32'd0; // sltu
      4'b1010: ALUOutM = ~(SrcAE | SrcBE); // nor
      4'b1100: ALUOutM = SrcAE - SrcBE; // sub
      4'b1101: ALUOutM = SrcBE << 32'd16; // lui
      4'b1110: ALUOutM = (as < bs) ? 32'd1 : 32'd0; // slt
      
      default: ALUOutM = 32'bx; // 
    endcase

  assign ZeroE = (ALUOutM == 32'b0);
endmodule
