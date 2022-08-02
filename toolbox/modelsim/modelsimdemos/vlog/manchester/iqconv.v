//////////////////////////////////////////////////
//  Top Level: Manchester Receiver (manchester.vhd)
//  This Level: IQ Convolution (iqconv.v)
//  Dependency: lfsr_reg13 (for test_bench)
//
//  Accepts raw data stream (samp) and convolves with I/Q 
//  pattern provided by "statecnt" entity.  The resulting
//  detected values are integrated into counters.  Use
//  reset to synchronously clear counters.
//
//  Copyright 2003-2004 The MathWorks, Inc.
//  $Revision: 1.1.6.2 $  $Date: 2004/04/08 20:55:12 $
//////////////////////////////////////////////////

`timescale 1 ns / 1 ns

module iqconv (clk, enable, reset, i_wf, q_wf, samp, isum, qsum);

input clk ;    // Clock (Sample Clock) (rising edge)
input enable ;    // Sync Clock Enable (active high)
input reset ;    // Sync Reset(active high)
		
input i_wf ;   // Inphase Decoding Waveform(from statecnt)
input q_wf ; // Quadrature Decoding Waveform(from statecnt)
input samp ; // raw sampled Manchester-encoded data

output [4:0] isum; // (max 17 with adjust)
output [4:0] qsum;   // (max 17 with adjust)

wire  idect;
wire  qdect;
reg  [4:0] icntv;
reg  [4:0] qcntv; 
wire [4:0] isum_internal;
wire [4:0] qsum_internal;

// 
assign #1 idect = samp ^ i_wf;  // Detector!  
assign #1 qdect = samp ^ q_wf;

assign isum_internal = icntv + idect;
assign qsum_internal = qcntv + qdect;

// synchronous process
always @(posedge clk)
  begin : iqc_proc
  if (reset == 1'b 1)            // async active high reset
    begin
    icntv <= 5'b 00000;  // reset state;
    qcntv <= 5'b 00000;  // reset state;
    end
    
  else if (enable == 1'b 1)
    begin
    icntv <= isum_internal;       // change state
    qcntv <= qsum_internal;      // change state      present_cnt <= next_cnt;       // change state
    end
 end //iqc_proc;

assign #1 isum = isum_internal;
assign #1 qsum = qsum_internal;

endmodule //iqconv
////////////////////////////////////////////////////
// [EOF] iqconv.v
