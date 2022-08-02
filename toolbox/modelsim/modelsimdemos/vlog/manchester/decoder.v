//////////////////////////////////////////////////
//  Top Level: Manchester Receiver (manchester.vhd)
//  This Level: Decoder (decode.v)
//  Dependency: none
//
//  Accepts convolved I/Q counts and produces the 
//  decoded data stream, validity, and adjustment
//  term to track drifts in the receive clock 
//- phase or frequency.  
//  
//  Simple combinatorial implementation
//  
//  Copyright 2003-2004 The MathWorks, Inc.
//  $Revision: 1.1.6.2 $  $Date: 2004/04/08 20:55:11 $
//////////////////////////////////////////////////

`timescale 1 ns / 1 ns
 
module decoder (isum, qsum, adj, dvalid, odata);

input  [4:0] isum; // Inphase measurement   (max 17 with period adjust)
input  [4:0] qsum; // Quadrature measurement(max 17 with period adjust)
  
output [1:0] adj; // Period adjustment direction, lead, lag or none
output  dvalid;  // Data validity, Set to 1 when phase error makes detection impossible
output  odata; // Recovered data stream

parameter midpt = 5'b 01000;  // 8

assign #1 odata = isum < midpt ? 1'b 1 : 1'b 0;
           
assign #1 dvalid = isum == midpt ? 1'b 0 : 1'b 1;
   
assign #1 adj = qsum == midpt && isum != midpt ? 2'b 00 // In phase
         : (qsum < midpt && isum < midpt) || (qsum >= midpt && isum >= midpt) ? 2'b 01 // Lead +1 
         : 2'b 11; // Lag -1 
endmodule //decoder

////////////////////////////////////////////////////
// [EOF] decoder.v


