module counter(
input clk_in, presetn,
input en, load, ud,
input count_enable,
input [7:0] reg_tdr,
output reg [7:0] cnt,
output reg [7:0] last_cnt

);

//COUNTER
always @(posedge clk_in or negedge presetn ) begin
  if(!presetn)
     cnt <= 1'b0;
  else begin
     if(load == 1'b1)
        cnt <= reg_tdr;
     else begin
        if(en==1'b0) //TCR[4]
	  cnt<=cnt;
	else
          if(count_enable == 1'b0)
	      cnt <= cnt;
	  else
	    if(ud==1'b1)
               cnt<= cnt-1'b1;
	    else 
	       cnt<= cnt+1'b1;
     end
   end
end
// LAST_CNT
always @(posedge clk_in or negedge presetn)
  if(!presetn)
    last_cnt <= 8'h00;
  else
    last_cnt <= cnt;

endmodule
