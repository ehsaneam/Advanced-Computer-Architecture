`timescale 1ns/1ns

module testbench;

   reg clk = 1;
   always @(clk)
      clk <= #5 ~clk;

   reg reset;
   initial begin
      reset = 0;
      @(posedge clk);
      @(posedge clk);
      @(posedge clk);
      #1;
      reset = 1;
   end

   initial
      $readmemh("isort32.hex", ACA_MIPS.im.RAM);

   parameter end_pc = 32'h80;

   integer i;
   always @(ACA_MIPS.PCF)
      if(ACA_MIPS.PCF == end_pc) begin
         for(i=0; i<96; i=i+1) begin
            $write("%x ", ACA_MIPS.dm.RAM[32+i]); // 32+ for iosort32
            if(((i+1) % 16) == 0)
               $write("\n");
         end
         $stop;
      end
  Top_ph1 ACA_MIPS(.CLK(clk) , .CLR(reset));


endmodule

