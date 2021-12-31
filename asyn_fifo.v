

  `timescale 1ns/1ns

 module fifo(
	  input winc,wclk,wrst,
	  input rinc,rclk,rrst,
	  input  [7:0] wdata,
	  output [7:0] rdata,
	  output full,empty );

  wire [3:0]waddr,raddr;
  wire [4:0]rptr,wptr;

  fifomem fmem(
               .wdata(wdata),
	       .waddr(waddr),.raddr(raddr),
	       .winc(winc),.wclk(wclk),.full(full),.empty(empty),.rclk(rclk),.rinc(rinc),
	       .rdata(rdata) );


   write wr(.winc(winc),
	    .rptr(rptr),
	    .wfull(full),
	    .wclk(wclk), .wrst_n(wrst),
	    .waddr(waddr),
	    .wptr(wptr) );


     read rd(
	      .rinc(rinc),
	      .wptr(wptr),
	      .empty(empty),
	      .rclk(rclk), .rrst_n(rrst),
	      .raddr(raddr),
	      .rptr(rptr)  );

   endmodule




 module fifomem(
             input [7:0]wdata,
	     input [3:0]waddr,raddr,
	     input winc,wclk,full,empty,rclk,rinc,
	     output reg [7:0] rdata );
   
   reg [7:0] mem [0:15] ;
 


   //assign wclken = (!full & winc) ;  

   always @(posedge wclk) begin   
	   if(winc && !full) begin
                  mem[waddr] <= wdata;
                end  
           //if(rinc & !empty) begin
	//	   rdata <= mem[raddr] ;
	  // end
      end

      always @(posedge rclk) begin  
	      if(rinc & !empty) begin
		   rdata <= mem[raddr] ;
	   end
      end


  endmodule


   module write(
	    input winc,
	    input [4:0]rptr,
	    output reg wfull,
	    input wclk,wrst_n,
	    output [3:0]waddr,
	    output reg [4:0]wptr );

    reg [4:0]wbin;
    wire [4:0] wgnext;
    wire [4:0] wbnext;
    reg [4:0] wq1_rptr,wq2_rptr; 
    wire full;

   assign waddr = wbin[3:0];
   assign wbnext = wbin + (winc && (!wfull));

   
   assign full = ((wgnext[4] != wq2_rptr[4] ) && (wgnext[3] != wq2_rptr[3]) && (wgnext[2:0] == wq2_rptr[2:0]));

    always @(posedge wclk, negedge wrst_n) begin
	    if(!wrst_n) begin
               wbin <= 4'd0;
	       wptr <= 4'd0; end
	    else begin
	       wbin <= wbnext;
               wptr <= wgnext; end
       end

    assign  wgnext = {wbnext[4],(wbnext[4]^wbnext[3]), (wbnext[3]^wbnext[2]), (wbnext[2]^wbnext[1]),(wbnext[1]^wbnext[0])};

    always @(posedge wclk, negedge wrst_n)
	  begin
	    if(!wrst_n) 
	         {wq2_rptr,wq1_rptr} <= 8'd0;
            else
		 {wq2_rptr,wq1_rptr} <= {wq1_rptr,rptr};
          end

	  always @(posedge wclk, negedge wrst_n)
          begin
	   if(!wrst_n) 
	      wfull <= 1'b0;
	   else
	      wfull <= full;
          end

    endmodule
	     
   module read(
	    input rinc,
	    input [4:0]wptr,
	    output reg empty,
	    input rclk,rrst_n,
	    output [3:0]raddr,
	    output reg [4:0]rptr  );
    
    wire rempty;
    reg [4:0]rbin;
    wire [4:0] rgnext;
    reg [4:0]rq2_wptr,rq1_wptr;
    wire [4:0]rbnext;

    always @(posedge rclk, negedge rrst_n)
	  begin
	    if(!rrst_n) 
	         {rq2_wptr,rq1_wptr} <= 8'd0;
            else
		 {rq2_wptr,rq1_wptr} <= {rq1_wptr,wptr};

          end

     always @(posedge rclk, negedge rrst_n) begin
	    if(!rrst_n) begin
              rbin <= 4'd0;
	      rptr <= 4'd0; end
	    else begin
	      rbin <= rbnext;
              rptr <= rgnext; end
       end 


    assign raddr = rbin[3:0];
    assign rbnext = rbin + (rinc && (!empty));
    assign rgnext = {rbnext[4],(rbnext[4]^rbnext[3]), (rbnext[3]^rbnext[2]), (rbnext[2]^rbnext[1]),(rbnext[1]^rbnext[0])};
     
   assign  rempty = (rq2_wptr == rgnext);
  
   always @(posedge rclk, negedge rrst_n)
   begin
	   if(!rrst_n) 
	      empty <= 1'b1;
	   else
	      empty <= rempty;
    end
  endmodule
   

    
           
             
