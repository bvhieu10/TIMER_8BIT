module register(
input pclk, presetn, psel, pwrite, penable,
input [7:0] paddr, pwdata,
input ovf_trig, udf_trig,
output reg pready, pslverr,
output reg [7:0] prdata, reg_tdr,
output en, load, ud,
output [1:0] cks,
output reg [1:0] clr_trig

);

`define WAIT_CYCLES 2
reg [1:0] count;
reg [2:0] select_reg;
reg [7:0] reg_tcr;
reg s_tmr_udf, s_tmr_ovf;

//OUTPUT TCR REGISTER
 assign load = reg_tcr[7];
 assign ud   = reg_tcr[5];
 assign en   = reg_tcr[4];
 assign cks  = reg_tcr[1:0];

 //decoder
 always @(paddr or negedge presetn) begin
	if(!presetn)
	  select_reg = 3'b000;
	else begin
	case (paddr)
	8'h00: select_reg = 3'b001;
	8'h01: select_reg = 3'b010;
	8'h02: select_reg = 3'b100;
	default: select_reg = 3'b000;
	endcase
 end
end
 //PSLVERR
 always @(posedge pclk or negedge presetn) begin
   if(!presetn) begin
	pslverr <= 1'b0;
   end
   else if(select_reg == 3'b000) begin
	pslverr <= 1'b1;
   end else begin
        pslverr <= 1'b0;
   end
 end
 
//PREADY
always @(posedge pclk or negedge presetn) begin
  if(!presetn) begin
    pready <= 1'b0;
    count  <= 2'b00;
  end 
  else if(psel && penable && count ==2'b00) begin
    #1;
    pready <= 1'b0;
  end 
  else if(psel) begin
    if(count == `WAIT_CYCLES) begin
      count <= 2'b00;
      #1;
      pready <= 1'b1;
    end
    else begin
    count <= count+1;
    end
  end
    else begin
    pready <= 1'b0;
    end
end

//REGISTER TDR
always @(posedge pclk or negedge presetn) begin
  if(!presetn)
    reg_tdr <= 8'h00;
  else begin
    if(psel && penable && pwrite && pready && select_reg[0])
      reg_tdr <= pwdata;
    else 
      reg_tdr <= reg_tdr;
   end
   end

//Register TCR
always @(posedge pclk or negedge presetn) begin
  if(!presetn)
    reg_tcr <= 8'h00;
  else begin
    if(psel && penable && pwrite && pready && select_reg[1]) begin
    	reg_tcr[7] <= pwdata[7];
	reg_tcr[5:4] <=pwdata[5:4];
	reg_tcr[1:0] <=pwdata[1:0];
    end else 
    	reg_tcr <= reg_tcr;
    end
end

//REGISTER TSR
//under_flow
always @(posedge pclk or negedge presetn) begin
  if(!presetn) begin
    s_tmr_udf <= 1'b0;
    clr_trig[1] <= 1'b0;
  end
  else begin //clear
    if(psel && penable && pwrite && pready && select_reg[2] && (!s_tmr_ovf || s_tmr_ovf && !pwdata[1]) &&( pwdata[1:0] != 2'b11)) begin
    s_tmr_udf <= pwdata[1];
    clr_trig[1] <=1'b0;
    end
    else if(udf_trig) begin //trigger
      s_tmr_udf <= 1'b1;
      clr_trig[1] <= 1'b1;
    end
    else begin
      s_tmr_udf <= s_tmr_udf;
      clr_trig[1] <=1'b0;
    end
  end
end

//over_flow
always @(posedge pclk or negedge presetn) begin
  if(!presetn) begin
    s_tmr_ovf <= 1'b0;
    clr_trig[0] <= 1'b0;
  end
  else begin
    if(psel && penable && pwrite && pready && select_reg[2] &&(!s_tmr_udf || s_tmr_udf && !pwdata[0])&&(pwdata[1:0] != 2'b11)) begin
    s_tmr_ovf <= pwdata[0];
    clr_trig[0] <=1'b0;
    end
    else if(ovf_trig) begin //trigger
      s_tmr_ovf <= 1'b1;
      clr_trig[0] <= 1'b1;
    end
    else begin
      s_tmr_ovf <= s_tmr_ovf;
      clr_trig[0] <=1'b0;
    end
  end
end


//ENCODER_PRDATA
always @(psel, penable, pwrite, select_reg) begin
  if(psel && penable && (!pwrite))
    case(select_reg)
      3'b001: prdata <=reg_tdr;
      3'b010: prdata <=reg_tcr;
      3'b100: prdata <={6'b000000, s_tmr_udf, s_tmr_ovf};
      default: prdata <=8'h00;
    endcase
  else
    prdata = prdata;
end
endmodule























