module tb_div_clock();

reg pclk, presetn;
reg [1:0] cks;
reg  pclk_2, pclk_4, pclk_8, pclk_16;
wire  clock_select;
clock_select DUT(.pclk(pclk), .presetn(presetn), .cks(cks), .clock_select(clock_select));
initial begin
 pclk=0;
 forever #10 pclk=~pclk;
end

initial begin
  #100;
  presetn=1'b0;
  #100;
  presetn=1'b1;
  cks=2'b00;
  #500;
  cks=2'b10;
  #500;
  presetn=1'b0;
  #100;
  $finish();
end

endmodule
