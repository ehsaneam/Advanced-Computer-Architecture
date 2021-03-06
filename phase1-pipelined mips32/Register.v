module Register #(parameter WIDTH = 1)(CLK,CLR,EN,d,q);
  input CLK,CLR,EN;
  input [WIDTH-1:0] d;
  output reg [WIDTH-1:0] q;
  always @(posedge CLK)begin
    if (~CLR & EN)
      q <= 0;
    if(EN)
      q <= d;
  end
endmodule
