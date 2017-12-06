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
         for(i=2; i<8; i=i+1) begin
            $write("%x %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x\n",
					ACA_MIPS.ct.DM.RAM[i][31:0],
					ACA_MIPS.ct.DM.RAM[i][63:32],
					ACA_MIPS.ct.DM.RAM[i][95:64],
					ACA_MIPS.ct.DM.RAM[i][127:96],
					ACA_MIPS.ct.DM.RAM[i][159:128],
					ACA_MIPS.ct.DM.RAM[i][191:160],
					ACA_MIPS.ct.DM.RAM[i][223:192],
					ACA_MIPS.ct.DM.RAM[i][255:224],
					ACA_MIPS.ct.DM.RAM[i][287:256],
					ACA_MIPS.ct.DM.RAM[i][319:288],
					ACA_MIPS.ct.DM.RAM[i][351:320],
					ACA_MIPS.ct.DM.RAM[i][383:352],
					ACA_MIPS.ct.DM.RAM[i][415:384],
					ACA_MIPS.ct.DM.RAM[i][447:416],
					ACA_MIPS.ct.DM.RAM[i][479:448],
					ACA_MIPS.ct.DM.RAM[i][511:480]
					); // 32+ for iosort32
            //if(((i+1) % 16) == 0)
              // $write("\n");
         end
         $stop;
      end
  Top_ph3 ACA_MIPS(.CLK(clk) , .CLR(reset));


endmodule

