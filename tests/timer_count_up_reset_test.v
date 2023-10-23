module timer_count_up_reset_test;
  reg [7:0] wdata, address, rdata;
  test_bench top();
  

  initial begin
  #100;
  $display("==================================");
  $display("=====COUNT UP RESET TEST==========");
  $display("==================================\n");
  $display("-STEP1- \n");
  $display("At time = %5d, write_data TCR \n", $time);
  top.cpu.apb_write(8'h01, 8'h10); // => up | enable | clk_in= clk2
  $display("----------------------------------\n");

  $display("-STEP2-\n");
  repeat(400) begin
    @(posedge top.pclk);
  end
  $display("-STEP2.1-\n");
  $display("At time = %5d, wait 200 clk_in done \n", $time);
  $display("-STEP2.2-\n");
  $display("At time = %5d, after 200 clk_in, read_data TSR \n", $time);
  top.cpu.apb_read(8'h02, rdata);
  if(rdata == 8'h00)
     $display("At time = %5d, TSR = 8'h%2h, NOT OVERFLOW -PASS- \n", $time, rdata);
  else begin
    top.fail = 1'b1;
    $display("At time = %5d, TSR = 8'h%2h, OVERFLOW -FAIL- \n", $time, rdata);
  end
  $display("----------------------------------\n");
  $display("-STEP3-\n");
  top.system.presetn = 1'b0;
  $display("At time = %5d", $time);
  $display("Preset = %d", top. system.presetn);
  #500;
  top.system.presetn = 1'b1;
  $display("At time = %5d", $time);
  $display("Preset = %d\n", top.system.presetn);
  //RESET done

  $display("-STEP4-\n"); 
  $display("At time = %5d, write_data TCR \n", $time);
  top.cpu.apb_write(8'h01, 8'h10);
  $display("--------------------------------------\n");

fork
    begin
      $display("--STEP5-- \n");
      $display("At time = %5d, wait OVF \n", $time);
        repeat(512) begin
          @(posedge top.pclk);
          end
          $display("--STEP6--\n");
          $display("At time = %5d, after 256 clk_in, read_data TSR \n", $time);
          top.cpu.apb_read(8'h02, rdata);
          if(rdata == 8'h01)
            $display("At time = %5d, TSR = 8'h%2h, OVERFLOW --PASS--\n", $time, rdata);
          else begin
            top.fail = 1'b1;
            $display("At time = %5d, TSR = 8'h%2h, NOT_OVERFLOW --FAIL--\n", $time, rdata);
          end
          $display("------------------------------------\n");
          end
 begin
       repeat(500) begin
         @(posedge top.pclk);
         end
       $display("--STEP5.1--\n");
       $display("At time = %5d, wait 250 clk_in, read_data TSR \n", $time);
       $display("--STEP5.2--\n");
       $display("At time = %5d, after 250 clk_in, read_data TSR \n", $time);
       top.cpu.apb_read(8'h02, rdata);
       if(rdata == 8'h00)
            $display("At time = %5d, TSR = 8'h%2h, NOT_OVERFLOW --PASS--\n", $time, rdata);
          else begin
            top.fail = 1'b1;
            $display("At time = %5d, TSR = 8'h%2h, OVERFLOW --FAIL--\n", $time, rdata);
          end
          $display("------------------------------------\n");
  end
        join

        $display("--STEP7--\n");
        $display("At time = %5d, clear TSR \n", $time);
        top.cpu.apb_write(8'h02, 8'h00);
        $display("------------------------------------\n");
        $display("--STEP8--\n");
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
        $display("--------------------------------\n");
        #100;
         top.display_result();
        $finish();
end
endmodule

