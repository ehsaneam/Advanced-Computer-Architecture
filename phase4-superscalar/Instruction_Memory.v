module Instruction_Memory(input [5:0] A,
            output [31:0] RD1,RD2,RD3,RD4);

  reg [31:0] RAM[63:0];

  assign RD1 = RAM[A];
  assign RD2 = RAM[A+1];
  assign RD3 = RAM[A+2];
  assign RD4 = RAM[A+3];
endmodule
