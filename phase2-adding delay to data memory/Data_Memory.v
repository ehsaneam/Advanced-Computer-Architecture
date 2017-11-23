`timescale 1ns/1ns

module Data_Memory(input CLK, WE, input [31:0] A, WD, output [31:0] RD);

  reg [31:0] RAM[127:0];

  assign #30 RD = RAM[A[31:2]];

  always @(posedge CLK)
    if (WE) 
      #30 RAM[A[31:2]] <= WD;
endmodule