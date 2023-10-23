module tcr_wr_rd_test();

//input
integer a=0;
reg [7:0] wdata, rdata;
//reg fail_flag=0;
//Testbench
test_bench top();

initial begin
  //reset depend on system_signal
  #100;
  $display("=========================================");
  $display("==========TEST WRITE READ TDR============");
  $display("=========================================");

  repeat(10) begin
       a=a+1;
       $display("\nTest No. %3d", a);
       wdata = $random();
       top.cpu.apb_write(8'h01, wdata);
       top.cpu.apb_read(8'h01, rdata);
	wdata={wdata[7], 1'b0, wdata[5:4], 2'b00, wdata[1:0]};
       if(wdata != rdata) begin
        $display("At time %4d, wdata = 8'h%2h, rdata = 8'h%2h, -- ERROR -- ", $time, wdata, rdata);
        top.fail=1'b1;
       end
       else begin
        $display("At time %4d, wdata = 8'h%2h, rdata = 8'h%2h, -- PASS -- ", $time, wdata, rdata);
       end
  end
  #500;
  top.display_result();
  $finish();
  end
endmodule

