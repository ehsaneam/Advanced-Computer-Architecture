module Data_Memory(input CLK, WE, input [31:0] Ar,Aw, WD, output [31:0] RD);

  reg [31:0] RAM[2047:0];

  assign RD = RAM[Ar[31:2]];

  always @(posedge CLK)
    if (WE) RAM[Aw[31:2]] <= WD;
endmodule