module timer_up_fake_ovf_test;
  reg [7:0] wdata, address, rdata;
  test_bench top();


  initial begin
    #100;
    $display("==================================");
    $display("=====COUNT UP FAKE OVF TEST=======");
    $display("==================================\n");
  
    $display("-PARTI- \n");
    $display("-STEP1- \n");
    $display("At time = %5d, write_data TDR \n", $time);
    top.cpu.apb_write(8'h00, 8'hff);
    
    top.cpu.apb_write(8'h01, 8'h80); 
    $display("----------------------------------\n");
  
    $display("-STEP2-\n");
    $display("At time = %5d, write_data TDR \n", $time);
    top.cpu.apb_write(8'h00, 8'h00);  
    top.cpu.apb_write(8'h01, 8'h80);
    $display("----------------------------------\n");
  
    $display("-STEP3-\n");
  
    $display("At time = %5d, read_data TSR\n", $time);
    top.cpu.apb_read(8'h02, rdata);
    if(rdata == 8'h00)
       $display("At time = %5d, TSR = 8'h%2h, NOT OVERFLOW -PASS- \n", $time, rdata);
    else begin
      top.fail = 1'b1;
      $display("At time = %5d, TSR = 8'h%2h, OVERFLOW -FAIL- \n", $time, rdata);
    end
    $display("----------------------------------\n");
  
    $display("-PARTII- \n");
    $display("-STEP1- \n");
    $display("At time = %5d, write_data TDR \n", $time);
    top.cpu.apb_write(8'h00, 8'hff);
    top.cpu.apb_write(8'h01, 8'h90); 
    $display("----------------------------------\n");
  
    $display("-STEP2-\n");
    $display("At time = %5d, write_data TDR \n", $time);
    top.cpu.apb_write(8'h00, 8'h00);
    top.cpu.apb_write(8'h01, 8'h90);
    $display("----------------------------------\n");
  
    $display("-STEP3-\n");
  
    $display("At time = %5d, read_data TSR\n", $time);
    top.cpu.apb_read(8'h02, rdata);
    if(rdata == 8'h00)
       $display("At time = %5d, TSR = 8'h%2h, NOT OVERFLOW -PASS- \n", $time, rdata);
    else begin
      top.fail = 1'b1;
      $display("At time = %5d, TSR = 8'h%2h, OVERFLOW -FAIL- \n", $time, rdata);
    end
  
    $display("----------------------------------\n");
    #100;
    top.display_result();
    $finish();
  end
endmodule












