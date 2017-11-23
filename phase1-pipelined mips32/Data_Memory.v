module Data_Memory(input CLK, WE, input [31:0] A, WD, output [31:0] RD);

  reg [31:0] RAM[127:0];

  assign RD = RAM[A[31:2]];

  always @(posedge CLK)
    if (WE) RAM[A[31:2]] <= WD;
endmodule