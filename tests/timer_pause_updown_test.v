module timer_pause_updown_test;
    reg [7:0] wdata, address, rdata;
    test_bench top();
 
 
    initial begin
    #100;
    $display("==================================");
    $display("=====COUNT UPDOWN PAUSE TEST========");
    $display("==================================\n");
    $display("-STEP1- \n");
    $display("At time = %5d, write_data TDR \n", $time);
    top.cpu.apb_write(8'h00, 8'h00);
    $display("At time = %5d, write_data TCR to LOAD \n", $time);
    top.cpu.apb_write(8'h01, 8'h80);
    $display("At time = %5d, write_data TCR to start count \n", $time);
    top.cpu.apb_write(8'h01, 8'h10);     // config count up
    $display("----------------------------------\n");
 
 
    $display("-STEP2-\n");
    $display("At time = %5d, wait OVF \n", $time);
    repeat(400) begin
      @(posedge top.pclk);
    end
    $display("----------------------------------\n");
    $display("-STEP3.1-\n");
    $display("At time = %5d, write_data TCR \n", $time);
    top.cpu.apb_write(8'h01, 8'h00);     //config Pause
    #500;
   $display("-STEP3.2-\n");
   $display("At time = %5d, write_data TCR \n", $time);
   top.cpu.apb_write(8'h01, 8'h30);      //config count down
   $display("----------------------------------\n");
   $display("-STEP4-\n");
   $display("At time = %5d, wait 56 clk_in \n", $time);
   repeat(512) begin
     @(posedge top.pclk);
   end
   $display("----------------------------------\n");
   $display("-STEP5-\n");
   $display("At time = %5d, after 56 clk_in, read_data TSR \n", $time);
   top.cpu.apb_read(8'h02, rdata);
   if(rdata == 8'h02)
     $display("At time = %5d, TSR = 8'h%2h, UNDERFLOW --PASS--\n", $time, rdata);
   else begin
     top.fail = 1'b1;
     $display("At time = %5d, TSR = 8'h%2h, NOT_UNDERFLOW --FAIL--\n", $time, rdata);
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
         $display("BIT UNDERFLOW CLEAR --PASS-- \n");
      end
      else begin
         $display("At time = %5d, TSR = 8'h%2h \n", $time, rdata);
         top.fail = 1'b1;
         $display("BIT UNDERFLOW NOT CLEAR --FAIL--\n");
      end
         $display("--------------------------------");
         #100;
         top.display_result();
         $finish();
  end
 endmodule




































