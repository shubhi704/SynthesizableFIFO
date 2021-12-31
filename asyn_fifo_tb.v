// Code your testbench here
// or browse Examples



  module test;

  reg winc,wclk,wrst;
  reg rinc,rclk,rrst;
  reg [7:0] wdata;
  wire [7:0] rdata;
  wire empty,full;

  fifo dut(
	   .winc(winc),.wclk(wclk),.wrst(wrst),
	   .rinc(rinc),.rclk(rclk),.rrst(rrst),
	   .wdata(wdata),
	   .rdata(rdata),
	   .full(full),.empty(empty) );
  
  initial begin
   rclk =0;
   forever #4 rclk = ~rclk;
  end

  initial begin
   wclk =0;
   forever #5 wclk = ~wclk;
  end

  
  integer i,j;

  initial begin
  wrst = 0; rrst=0;  
  @(negedge wclk); wrst=1; rrst = 1; winc = 0; rinc = 0; 
 
    @(negedge wclk);
    for(i=0; i<20; i=i+1)
       begin winc = 1; 
          wdata = {$random};
             
             @(negedge wclk);
    end
    
    @(negedge wclk);
    @(negedge rclk);  winc=0; 
    for(j=0; j<20; j=j+1)
      begin rinc = 1;
            @(negedge rclk);
       end
    repeat(4) @(negedge rclk); $finish;
    end
  
 initial
 begin
 $dumpfile("asyn_fifo.vcd");
 $dumpvars;
 end

 endmodule

   
   
   

