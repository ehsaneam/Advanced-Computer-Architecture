`timescale 1ns/1ns

module testbench;
   reg clk = 1;
   reg [31:0] ram [1023:0];
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
         for(i=0; i<64; i=i+1) begin
			ram[16*i+0] = ACA_MIPS.ct.DM.RAM[i][31:0];
			ram[16*i+1] = ACA_MIPS.ct.DM.RAM[i][63:32];
			ram[16*i+2] = ACA_MIPS.ct.DM.RAM[i][95:64];
			ram[16*i+3] = ACA_MIPS.ct.DM.RAM[i][127:96];
			ram[16*i+4] = ACA_MIPS.ct.DM.RAM[i][159:128];
			ram[16*i+5] = ACA_MIPS.ct.DM.RAM[i][191:160];
			ram[16*i+6] = ACA_MIPS.ct.DM.RAM[i][223:192];
			ram[16*i+7] = ACA_MIPS.ct.DM.RAM[i][255:224];
			ram[16*i+8] = ACA_MIPS.ct.DM.RAM[i][287:256];
			ram[16*i+9] = ACA_MIPS.ct.DM.RAM[i][319:288];
			ram[16*i+10] = ACA_MIPS.ct.DM.RAM[i][351:320];
			ram[16*i+11] = ACA_MIPS.ct.DM.RAM[i][383:352];
			ram[16*i+12] = ACA_MIPS.ct.DM.RAM[i][415:384];
			ram[16*i+13] = ACA_MIPS.ct.DM.RAM[i][447:416];
			ram[16*i+14] = ACA_MIPS.ct.DM.RAM[i][479:448];
			ram[16*i+15] = ACA_MIPS.ct.DM.RAM[i][511:480];
		end 
		for(i=32; i<128; i=i+1) begin// 32+ for iosort32
			$write("%x ",ram[i]);
            if(((i+1) % 16) == 0)
              $write("\n");
         end
         $stop;
      end
  Top_ph3 ACA_MIPS(.CLK(clk) , .CLR(reset));


endmodule

