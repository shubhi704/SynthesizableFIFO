module sync_r2w
(input rclk,
input rrst_n
,input [4:0]rptr, 
output reg [4:0]rq2_wptr);

reg [4:0]temp ; 

always @(posedge rclk,negedge rrst_n)
   if(!wrst_n)
      {rq2_wptr,temp} <= 4'd0;
  else 
      {rq2_wptr,temp} <= {temp,wptr} ; 

endmodule