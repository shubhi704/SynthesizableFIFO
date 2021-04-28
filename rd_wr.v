module sync_r2w
(input wclk,
input wrst_n
,input [4:0]rptr, 
output reg [4:0]wq2_rptr);

reg [4:0]temp ; 

always @(posedge wclk,negedge wrst_n)
   if(!wrst_n)
      {wq2_rptr,temp} <= 4'd0;
  else 
      {wq2_rptr,temp} <= {temp,rptr} ; 

endmodule