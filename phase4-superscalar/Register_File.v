module Register_File(input         CLK, WE1,WE2,
               input  [4:0]  Ar1, Ar2, Ar3 , Ar4 , Ar5, Ar6, Ar7, Ar8, Aw1 , Aw2,
               input  [31:0] WD1,WD2,
               output [31:0] RD1, RD2,RD3, RD4,RD5, RD6,RD7, RD8 );

  reg [31:0] rf[31:0];

  always @(negedge CLK)begin
    if (WE1) rf[Aw1] <= WD1;	//for writing on reg if needed
	if (WE2) rf[Aw2] <= WD2;
  end

  assign RD1 = (Ar1 != 0) ? rf[Ar1] : 32'b0; //reading from reg if reg #0 selected output will be hardwired to 0
  assign RD2 = (Ar2 != 0) ? rf[Ar2] : 32'b0;
  assign RD3 = (Ar3 != 0) ? rf[Ar3] : 32'b0;
  assign RD4 = (Ar4 != 0) ? rf[Ar4] : 32'b0;
  assign RD5 = (Ar5 != 0) ? rf[Ar5] : 32'b0; 
  assign RD6 = (Ar6 != 0) ? rf[Ar6] : 32'b0;
  assign RD7 = (Ar7 != 0) ? rf[Ar7] : 32'b0;
  assign RD8 = (Ar8 != 0) ? rf[Ar8] : 32'b0;
endmodule