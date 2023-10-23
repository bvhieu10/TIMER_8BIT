module test_bench();

wire [7:0] paddr, pwdata, prdata;
wire pclk, presetn,  psel, pwrite, penable, pready, pslverr;
reg fail = 1'b0;

//Reference signals
wire s_tmr_udf, s_tmr_ovf;
assign s_tmr_udf= dut.reg_inst.s_tmr_udf;
assign s_tmr_ovf= dut.reg_inst.s_tmr_ovf;

//ip
timer dut(
	.pclk(pclk),
	.presetn(presetn),
	.psel(psel),
	.penable(penable),
	.pwrite(pwrite),
	.paddr(paddr),
	.pwdata(pwdata),
	.prdata(prdata),
	.pready(pready),
	.pslverr(pslverr)

);

//vip
system_signal system (
	.pclk(pclk),
	.presetn(presetn)
);

cpu_model cpu (
	.cpu_clk(pclk),
	.cpu_rstn(presetn),
	.cpu_pslverr(pslverr),
	.cpu_pready(pready),
	.cpu_penable(penable),
	.cpu_pwrite(pwrite),
	.cpu_psel(psel),
	.cpu_paddr(paddr),
	.cpu_prdata(prdata),
	.cpu_pwdata(pwdata)
);

task display_result();
  if(fail == 1'b1) begin
	$display("=============================");
	$display("=========TEST FAIL===========");
	$display("=============================");
  end
  else begin
	$display("=============================");
	$display("=========TEST PASS===========");
	$display("=============================");
  end
  endtask
endmodule
