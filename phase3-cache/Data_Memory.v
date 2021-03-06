`timescale 1ns/1ns

module Data_Memory(input CLK, WE, input [31:0] A,input [511:0] WD, output [511:0] RD);

  reg [511:0] RAM[127:0];

  assign #30 RD = RAM[A[15:6]];
  always @(posedge CLK)
    if (WE) 
      #30 RAM[A[15:6]] <= WD;
endmodule