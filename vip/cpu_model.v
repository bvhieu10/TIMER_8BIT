module cpu_model(

input   wire cpu_clk,cpu_rstn, cpu_pready, cpu_pslverr,
input 	wire [7:0] cpu_prdata, 
output reg  cpu_pwrite, cpu_psel, cpu_penable,
output reg [7:0] cpu_pwdata, cpu_paddr 
);

task apb_write( input [7:0] address,input [7:0] wdata); //testbench dua vao model
  begin
    //setup-phase-> slave
    @(posedge cpu_clk);
    #1;
    cpu_paddr = address;
    cpu_pwrite= 1;
    cpu_psel  = 1;
    cpu_pwdata= wdata;

    //access phase
    @(posedge cpu_clk);
    #1;
    cpu_penable=1;
    $display("At %0t start writing wdata= %0h to address= %0h", $time, wdata, address );

    //waite pready
    @(posedge cpu_clk);
    while(!cpu_pready) begin
      @(posedge cpu_clk);
    end

    //end access
    // occur @posedge clk
    #1;
    // cpu_paddr=0;
    cpu_psel=0;
    cpu_penable=0;
    //cpu_pready=0;
    cpu_pwrite=0;
    cpu_pwdata=8'h00;
    $display("At %0t write trafer has been finish", $time);
    end
endtask

task apb_read(
  input  [7:0] address,
  output [7:0] rdata);  //=> sign tu slave tra ve prdata => rdata => testbench
  begin
    //setup-phase-> slave
    @(posedge cpu_clk);
    #1;
    cpu_paddr=address;
    cpu_pwrite=1'b0;
    cpu_psel=1'b1;

    //access phase
    @(posedge cpu_clk);
    #1;
    cpu_penable=1;
    $display("At %0t start reading rdata at address= %0h", $time, address );
    //waite pready
    @(posedge cpu_clk) begin
    while(!cpu_pready)
      @(posedge cpu_clk);
    end

    //end access
    // occur @posedge clk
    rdata= cpu_prdata;
    $display("At %0t rdata= %0h", $time, rdata);

    #1;
    cpu_paddr=0;
    cpu_psel=0;
    cpu_penable=0;
    cpu_pwrite=0;
    $display("At %0t read trafer has been finish", $time);

  end
endtask

endmodule

