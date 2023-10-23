module system_signal(
       output reg pclk,
       output reg presetn
);

initial begin
  pclk=0;
  #10;
  forever #10 pclk=~pclk;
end

initial begin
    presetn=1;
    #20; 
    presetn=0;
    #20; 
    presetn=1;

end
endmodule

