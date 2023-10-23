module tsr_wr_rd_test();

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
  $display("==========TEST WRITE READ TSR============");
  $display("=========================================");

  repeat(10) begin
       a=a+1;
       $display("\nTest No. %3d", a);
       wdata = $random();
       top.cpu.apb_write(8'h02, wdata);
       #1;
       top.cpu.apb_read(8'h02, rdata);
       
       if(rdata == 8'h00)
          $display("At time %5d, wdata = 8'h%2h, rdata = 8'h%2h, --PASS--\n", $time, wdata, rdata);
       else begin
          top.fail =1'b1;
          $display("At time %5d, wdata = 8'h%2h, rdata = 8'h%2h, --FAIL--\n", $time, wdata, rdata);
       end
  end
  #500;
  top.display_result();
  $finish();
  end
endmodule
