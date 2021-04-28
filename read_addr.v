module rfifo(rinc,rempty,raddr,rptr,rq2_wptr,rrst_n,rclk);

input rrst_n,rclk,rinc;
input [4:0]rq2_wptr;

output reg rempty;
output reg [4:0]rptr;
output [3:0]raddr;

reg [4:0]rbin;
wire [4:0]bin_addr;

always @(posedge rclk,negedge rrst_n)
   if(!rrst_n)
       {rbin,rptr} <= 0;
   else 
       {rbin,rptr} <= {bin_addr,raddr} ;
assign raddr = rbin[3:0] ;
assign bin_addr = rbin + (rbin & ~rempty) ; 
assign raddr = ((bin_addr>>1) ^ bin_addr ) ;

assign rempty_val = (rq2_wptr == raddr) ;

always @(posedge rclk,negedge rrst_n)
   if(!rrst_n)
       rempty <= 1;
   else
       rempty <= rempty_val;

endmodule