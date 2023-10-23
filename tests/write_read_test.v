module write_read_test;

reg [7:0] wdata, address, rdata;
integer a=0;

test_bench top();

//TEST PROCCESS
 initial begin
   #200;
   $display("==============================");
   $display("=====WRITE - READ - TEST=======");
   $display("==============================");
   repeat(100) begin
     a=a+1;
     $display(" TEST NO %3d\n", a);
     address[7:3] = 5'b00000;
     address[2:0] = $random();
     wdata = $random();
     wdata[4] =0;  //disable TIMER
     top.cpu.apb_write(address, wdata);
     top.cpu.apb_read(address, rdata);
      
        if(address <8'h03) begin
	    $display("Valid Address");
	    if(address == 8'h02) begin
	       if(rdata == wdata[1:0])
	           $display("At time %5d, wdata = 8'h%2h, rdata = 8'h%2h, --PASS--\n", $time, wdata, rdata);
	       else if((rdata != wdata[1:0]) && (rdata == 8'h00))
	                  $display("At time %5d, wdata = 8'h%2h, rdata = 8'h%2h, --PASS--\n", $time, wdata, rdata);
                    else begin
	                  top.fail =1'b1;
	                  $display("At time %5d, wdata = 8'h%2h, rdata = 8'h%2h, --FAIL--\n", $time, wdata, rdata);
	            end
	    end
	    else if(address == 8'h01) begin
	               wdata = {wdata[7],1'b0, wdata[5:4], 2'b00, wdata[1:0]};
	               if(rdata == wdata) 
	                    $display("At time %5d, wdata = 8'h%2h, rdata = 8'h%2h, --PASS--\n", $time, wdata, rdata);
	               else begin
	                    top.fail = 1'b1;
	                    $display("At time %5d, wdata = 8'h%2h, rdata = 8'h%2h, --FAIL--\n", $time, wdata, rdata);
			    end
	           end
	           else begin
	                    if(rdata==wdata) 
	                         $display("At time %5d, wdata = 8'h%2h, rdata = 8'h%2h, --PASS--\n", $time, wdata, rdata);
	                    else begin
	                         top.fail = 1'b1;
	                         $display("At time %5d, wdata = 8'h%2h, rdata = 8'h%2h, --FAIL--\n", $time, wdata, rdata);
	                         end
                        end
        end
        else begin
             $display("Invalid Address\n");
             end
    end
    $display("---------------------------------------------\n");
    #100;
    top.display_result();
    $finish();

    end
endmodule
