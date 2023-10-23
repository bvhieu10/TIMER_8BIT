module timer_count_down_reset_test;
  reg [7:0] wdata, address, rdata;
  test_bench top();


  initial begin
  #100;
  $display("==================================");
  $display("=====COUNT DOWN RESET TEST========");
  $display("==================================\n");
  $display("-STEP1- \n");
  top.cpu.apb_write(8'h00, 8'hff);
  #1;
  top.cpu.apb_write(8'h01, 8'h80); //only load value in TCR from TDR
  $display("At time = %5d, write_data TCR \n", $time);
  top.cpu.apb_write(8'h01, 8'h30); // => config count down | enable | clk_in= clk2
  $display("----------------------------------\n");

  $display("-STEP2-\n");
  repeat(400) begin
    @(posedge top.pclk);
  end
  $display("-STEP2.1-\n");
  $display("At time = %5d, wait 200 clk_in done \n", $time);
  $display("-STEP2.2-\n");
  $display("At time = %5d, after 200 clk_in, read_data TSR \n", $time);
  top.cpu.apb_read(8'h02, rdata);   // check underflow
  if(rdata == 8'h00)
     $display("At time = %5d, TSR = 8'h%2h, NOT UNDERFLOW -PASS- \n", $time, rdata);
  else begin
    top.fail = 1'b1;
    $display("At time = %5d, TSR = 8'h%2h, UNDERFLOW -FAIL- \n", $time, rdata);
  end
  $display("----------------------------------\n");

  $display("-STEP3-\n");
  top.system.presetn = 1'b0;// ON RESETN
  $display("At time = %5d", $time);
  $display("Preset = %d", top. system.presetn);
  #500;
  top.system.presetn = 1'b1;  //OFF RESETN
  $display("At time = %5d", $time);
  $display("Preset = %d\n", top.system.presetn);
  //RESET done

  $display("===========DOC TSR===================");
  top.cpu.apb_read(8'h02, rdata);

  $display("At time = %5d, TSR = 8'h%2h\n", $time, rdata);

  $display("-STEP4-\n");
  $display("At time = %5d, write_data TCR \n", $time);
  top.cpu.apb_write(8'h01, 8'h30); // count down after reset
  $display("--------------------------------------\n");

//CHECK UNDERFLOW
    begin  
      $display("--STEP5-- \n");
      $display("At time = %5d, wait UDF \n", $time);
        repeat(100) begin
          @(posedge top.pclk);
          end
          $display("--STEP6--\n");
          $display("At time = %5d, after 256 clk_in, read_data TSR \n", $time);
          top.cpu.apb_read(8'h02, rdata);
          if(rdata == 8'h02)
            $display("At time = %5d, TSR = 8'h%2h, UNDERFLOW --PASS--\n", $time, rdata);
          else begin
            top.fail = 1'b1;
            $display("At time = %5d, TSR = 8'h%2h, NOT_UNDERFLOW --FAIL--\n", $time, rdata);
          end
          $display("------------------------------------\n");
          end

//CLEAR TSR
        $display("--STEP7--\n");
        $display("At time = %5d, clear TSR \n", $time);
        top.cpu.apb_write(8'h02, 8'h00);
        $display("------------------------------------\n");
        $display("--STEP8--\n");
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
          $display("--------------------------------\n");
          #100;
          top.display_result();
          $finish();
end
endmodule





























