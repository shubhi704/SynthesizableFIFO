module fifomemory
 (output [7:0] rdata,
 input [7:0] wdata,
 input [3:0] waddr, raddr,
 input wclken, wfull, wclk);

 reg [7:0] mem [0:3];

 assign rdata = mem[raddr];
 
 always @(posedge wclk)
    if (wclken && !wfull)
       mem[waddr] <= wdata;
 
endmodule

