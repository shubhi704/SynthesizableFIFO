module wfifo(winc,wfull,waddr,wptr,wq2_rptr,wrst_n,wclk);

input wrst_n,wclk,winc;
input [4:0]wq2_rptr;
output wfull,wptr;
output [4:0]waddr;

reg [4:0]wbin;
wire [4:0]bin_addr;

always @(posedge wclk,negedge wrst_n)
   if(!wrst_n)
       {wbin,wptr} <= 0;
   else 
       {wbin,wptr} <= {bin_addr,waddr} ;

assign bin_addr = wbin + (wbin & ~wfull) ; 
assign waddr = ((bin_addr>>1) ^ bin_addr) ;


assign wfull_val = ((wq2_rptr[4:3] != waddr[4:3]) && (wq2_rptr[2:0] == waddr[2:0]) ;

always @(posedge wclk,negedge wrst_n)
   if(!wrst_n)
       wfull <= 0;
   else
       wfull <= wfull_val;