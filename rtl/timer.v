module timer(
input pclk, presetn, psel, pwrite, penable,
input [7:0] pwdata, paddr,
output [7:0] prdata,
output pslverr, pready
);

wire en, load, ud;
wire count_enable;
wire [7:0] reg_tdr;
wire [7:0] cnt;
wire [7:0] last_cnt;
wire [1:0] cks;
wire ovf_trig;
wire udf_trig;
wire clk_in;
wire [1:0] clr_trig;

counter cnt_inst(
	.clk_in(clk_in),
	.presetn(presetn),
	.en(en),
	.load(load),
	.ud(ud),
	.count_enable(count_enable),
	.cnt(cnt),
	.last_cnt(last_cnt),
	.reg_tdr(reg_tdr)
);

clock_select  clk_inst(
	.pclk	(pclk),
	.presetn(presetn),
	.cks(cks),
	.clk_in(clk_in)
);

register reg_inst(
	.paddr(paddr),
	.pclk(pclk),
	.presetn(presetn),
	.penable(penable),
	.psel(psel),
	.pwrite(pwrite),
	.pwdata(pwdata),
	.ovf_trig(ovf_trig),
	.udf_trig(udf_trig),
	.pready(pready),
	.pslverr(pslverr),
	.prdata(prdata),
	.reg_tdr(reg_tdr),
	.en(en),
	.load(load),
	.ud(ud),
	.cks(cks),
	.clr_trig(clr_trig)

);

ctr_logic ctr_logic_inst(
 .pclk(pclk),
 .presetn(presetn),
 .clk_in(clk_in),
 .clr_trig(clr_trig),
 .ud(ud),
 .en(en),
 .load(load),
 .cnt(cnt),
 .last_cnt(last_cnt),
 .udf_trig(udf_trig),
 .ovf_trig(ovf_trig),
 .count_enable(count_enable)

);
endmodule
