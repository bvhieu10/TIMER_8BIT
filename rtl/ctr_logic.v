module ctr_logic(
input pclk, presetn, clk_in,
input [1:0] clr_trig,
input ud, en, load,
input [7:0] cnt, 
input [7:0] last_cnt,
output reg udf_trig,
output reg ovf_trig,
output count_enable
);

reg last_clk_in;

//EDGE DETECTOR
always @(posedge pclk or negedge presetn) begin
  if(!presetn)
    last_clk_in <= 1'b0;
  else
    last_clk_in <= clk_in;
    end

assign count_enable =(~last_clk_in)&(clk_in);

//UDF trigger
always @(posedge pclk or negedge presetn) begin
  if(!presetn) begin
    udf_trig <= 1'b0;
  end
  else begin
    if(clr_trig[1]) begin
      udf_trig <= 1'b0;
    end
    else begin
      if((last_cnt == 8'h00)&&(cnt == 8'hff)&&(en)&&(~load)&&(ud) )
        udf_trig <= 1'b1;
      else
        udf_trig <= udf_trig;
      end
    end

end

//OVF trigger
always @( posedge pclk or negedge presetn) begin
  if(!presetn) begin
    ovf_trig <= 1'b0;
  end
  else begin
    if(clr_trig[0]) begin
      ovf_trig <= 1'b0;
    end
    else begin
      if((last_cnt == 8'hff)&&(cnt == 8'h00)&&(en)&&(~load)&&(!ud))
        ovf_trig <= 1'b1;
      else
        ovf_trig <= ovf_trig;
      end
    end

end

endmodule





