module Register_File(input         CLK, 
               input         WE3, 
               input  [4:0]  A1, A2, A3, 
               input  [31:0] WD3, 
               output [31:0] RD1, RD2);

  reg [31:0] rf[31:0];

  always @(negedge CLK)
    if (WE3) rf[A3] <= WD3;	//for writing on reg if needed

  assign RD1 = (A1 != 0) ? rf[A1] : 32'b0; //reading from reg if reg #0 selected output will be hardwired to 0
  assign RD2 = (A2 != 0) ? rf[A2] : 32'b0;
endmodule