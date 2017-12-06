module Instruction_Memory(input [5:0] A,
            output [31:0] RD);

  reg [31:0] RAM[63:0];

  //initial
      //$readmemh("isort32.hex",RAM);

  assign RD = RAM[A];
endmodule
