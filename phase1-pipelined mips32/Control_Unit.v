module Control_Unit(input [5:0] Op, Funct,
                  output MemtoRegD, MemWriteD,ALUSrcD, RegDstD, RegWriteD,BranchD,BNED,ExtndD,
                  output [3:0] ALUControlD);
  wire [3:0] aluop;

  maindec md(Op, MemtoRegD, MemWriteD, BranchD, BNED, ExtndD,
             ALUSrcD, RegDstD, RegWriteD, aluop);
  aludec  ad(Funct, aluop, ALUControlD);
  
endmodule

module maindec(input  [5:0] op, output memtoreg, memwrite, branch, bne, extend, alusrc,
               output wire regdst, regwrite, output [3:0] aluop);

  reg [11:0] controls;

  assign {extend, regwrite, regdst, alusrc, branch, bne, memwrite,
          memtoreg, aluop} = controls;

  always @(*)
    case(op)
      6'b000000: controls <= 12'b111000001000; // RTYPE
      6'b100011: controls <= 12'b110100010000; // LW
      6'b101011: controls <= 12'b100100100000; // SW
      6'b000100: controls <= 12'b100010000100; // BEQ
      6'b001000: controls <= 12'b110100000000; // ADDI
      6'b001001: controls <= 12'b110100000000; // ADDIU
      6'b001101: controls <= 12'b010100000110; // ORI
      6'b001110: controls <= 12'b010100000010; // XORI
      6'b001001: controls <= 12'b110100000000; // ADDIU
      6'b001100: controls <= 12'b010100001110; // ANDI
      6'b001010: controls <= 12'b110100001010; // SLTI
      6'b001011: controls <= 12'b010100001100; // STTIU
      6'b001111: controls <= 12'b010100000001; // LUI
      6'b000101: controls <= 12'b100011000100; // BNE
      default:   controls <= 12'bxxxxxxxxxxxx; // illegal op
    endcase
endmodule

module aludec(input  wire [5:0] funct,
              input  wire [3:0] aluop,
              output reg [3:0] alucontrol);

  always @(*)
    case(aluop)
      4'b0000: alucontrol <= 4'b0100;  // add (for lw/sw/addi)
      4'b0110: alucontrol <= 4'b0010;  // ori
      4'b0100: alucontrol <= 4'b1100;  // sub (for beq/bne)
      4'b0010: alucontrol <= 4'b0110;  // xori
      4'b0111: alucontrol <= 4'b0000;  // andi
      4'b1010: alucontrol <= 4'b1110;  // slti
      4'b1100: alucontrol <= 4'b1000;  // sltiu
      4'b0001: alucontrol <= 4'b1101;  // lui
      default: case(funct)          // R-type instructions aluop 101
          6'b100000: alucontrol <= 4'b0100; // add
          6'b100001: alucontrol <= 4'b0100; // addu
          6'b100010: alucontrol <= 4'b1100; // sub
          6'b100100: alucontrol <= 4'b0000; // and
          6'b100101: alucontrol <= 4'b0010; // or
          6'b101010: alucontrol <= 4'b1110; // slt
          6'b101011: alucontrol <= 4'b1000; // sltu
          6'b100110: alucontrol <= 4'b0110; // xor
          6'b100111: alucontrol <= 4'b1010; // nor
          6'b000100: alucontrol <= 4'b0001; // sllv
          6'b000111: alucontrol <= 4'b0011; // srav
          6'b000110: alucontrol <= 4'b0101; // srlv
          default:   alucontrol <= 4'bxxxx; // illegal op x101
        endcase
    endcase
endmodule