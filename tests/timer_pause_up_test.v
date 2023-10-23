module timer_pause_up_test;
    reg [7:0] wdata, address, rdata;
    test_bench top();
 
 
    initial begin
    #100;
    $display("==================================");
    $display("========COUNT DOWN UP TEST========");
    $display("==================================\n");
    $display("-STEP1- \n");
    $display("At time = %5d, write_data TDR \n", $time);
    top.cpu.apb_write(8'h00, 8'h00);
    $display("At time = %5d, write_data TCR to LOAD \n", $time);
    top.cpu.apb_write(8'h01, 8'h80);   //only load value in TCR | 8'h80: 1000_0000 
    $display("At time = %5d, write_data TCR to start count \n", $time);
    top.cpu.apb_write(8'h01, 8'h10);   //config count TCR | 8'h10: 0001_0000
    $display("----------------------------------\n");
 
 
    $display("-STEP2-\n");
    $display("At time = %5d, wait OVF \n", $time);
    repeat(400) begin                 
      @(posedge top.pclk);
    end
    $display("----------------------------------\n");
    $display("-STEP3.1-\n");
    $display("At time = %5d, write_data TCR \n", $time);
    top.cpu.apb_write(8'h01, 8'h00);   //config pause TCR | 8'h00 |disenable |discount
    #500;
  	$display("-STEP3.2-\n");
    $display("At time = %5d, write_data TCR \n", $time);
    top.cpu.apb_write(8'h01, 8'h10);   //config continue count up |8'h30 |1
    $display("----------------------------------\n");
    $display("-STEP4-\n");
    $display("At time = %5d, wait 56 clk_in \n", $time);
    repeat(112) begin
      @(posedge top.pclk);
    end
    $display("----------------------------------\n");
    $display("-STEP5-\n");
    $display("At time = %5d, after 56 clk_in, read_data TSR \n", $time);
    top.cpu.apb_read(8'h02, rdata);
    if(rdata == 8'h01)
      $display("At time = %5d, TSR = 8'h%2h, OVERFLOW --PASS--\n", $time, rdata);
    else begin
      top.fail = 1'b1;
      $display("At time = %5d, TSR = 8'h%2h, NOT_OVERFLOW --FAIL--\n", $time, rdata);
      end
      $display("------------------------------------\n");
 
 
      $display("--STEP6--\n");
      $display("At time = %5d, clear TSR \n", $time);
      top.cpu.apb_write(8'h02, 8'h00);
      $display("------------------------------------\n");
      $display("--STEP7--\n");
      $display("At time = %5d, read_data TSR \n", $time);
      top.cpu.apb_read(8'h02, rdata);
      if(rdata == 8'h00) begin
  		$display("At time = %5d, TSR = 8'h%2h \n", $time, rdata);
         $display("BIT OVERFLOW CLEAR --PASS-- \n");
      end
      else begin
         $display("At time = %5d, TSR = 8'h%2h \n", $time, rdata);
         top.fail = 1'b1;
         $display("BIT OVERFLOW NOT CLEAR --FAIL--\n");
      end
         $display("--------------------------------");
         #100;
         top.display_result();
         $finish();
  end
 endmodule

