# Synchronous_sysnthesis_FIFO

This is a Synchronous systheziable FIFO design. 
For synchronous FIFO design (a FIFO where writes to, and reads from the FIFO buffer are conducted in the same
 clock domain), one implementation counts the number of writes to, and reads from the FIFO buffer to increment (on
 FIFO write but no read), decrement (on FIFO read but no write) or hold (no writes and reads, or simultaneous write
 and read operation) the current fill value of the FIFO buffer. The FIFO is full when the FIFO counter reaches a
 predetermined full value and the FIFO is empty when the FIFO counter is zero.
To understand this design I recommend you to follow Sunburst Paper. 
