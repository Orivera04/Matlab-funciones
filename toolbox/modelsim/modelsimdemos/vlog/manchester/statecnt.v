////////////////////////////////////////////////////
//  Top Level: Manchester Receiver (manchester.vhd)
//  This Level: State Counter (statecnt.v)
//  Dependency: none
//
//  Controller for Manchester Receiver
//  
//  Input Ports
//   adj(2) <- Phase Adjustment (from decode)
//   clk    <- Sample Clock (approx 16x Data Clock)
//   reset  <- Reset to initial state
//   
//  Output Ports
//   sync   -> clk enable indicating decoded data value
//              This will occur approximately every 16 sample clocks
//   i_wf   ->    
//   q_wf   ->
//
//  Copyright 2003-2004 The MathWorks, Inc.
//  $Revision: 1.1.6.2 $  $Date: 2004/04/08 20:55:13 $
///////////////////////////////////////////////////

`timescale 1 ns / 1 ns
  
module statecnt (clk, enable, reset, adj, sync, i_wf, q_wf);

input  clk;    // Clock (Sample Clock) (rising edge)
input  enable;    // Sync Clock Enable (active high)
input  reset;    // Sync Reset(active high)
  		
input  [1:0] adj;  // Data Rate adjust "00","01" or "10"
		
output sync;   // Data clock (approx freq(sclk)/16)

output i_wf;   // Inphase Decoding Waveform (to iqconv)
output q_wf;   // Quadrature Decoding Waveform (to iqconv)

reg sync_r;
reg i_wf_r;
reg q_wf_r;

//STATE TYPE
parameter LEAD_START  = 5'b 00000;  // Extra cycle (17) if lead detected
parameter NORMAL_START = 5'b 00001;  // Normal 
parameter LAG_START = 5'b 00010;
parameter STATE_3 = 5'b 00011;
parameter STATE_4 = 5'b 00100;
parameter STATE_5 = 5'b 00101;
parameter STATE_6 = 5'b 00110;
parameter STATE_7 = 5'b 00111;
parameter STATE_8 = 5'b 01000;
parameter STATE_9 = 5'b 01001;
parameter STATE_A = 5'b 01010;
parameter STATE_B = 5'b 01011;
parameter STATE_C = 5'b 01100;
parameter STATE_D = 5'b 01101;
parameter STATE_E = 5'b 01110;
parameter STATE_F = 5'b 01111;
parameter DECODE_ME = 5'b 10000;  // Last cycle
               
reg [4:0] state;
reg [4:0] next_state;

// State register Update
always @ (posedge clk)
  begin : seq
  if (reset == 1'b 1)
    #1 state <= NORMAL_START;
  else if (enable == 1'b 1)
    #1 state <= next_state;
  end
  
// Next State and Ouput Logic
always @(state or adj)
  begin : com
  case (state)
    LEAD_START      : #1 next_state <= NORMAL_START;
    NORMAL_START    : #1 next_state <= LAG_START;
    LAG_START       : #1 next_state <= STATE_3;    
    STATE_3         : #1 next_state <= STATE_4;
    STATE_4         : #1 next_state <= STATE_5;
        
    STATE_5         : #1 next_state <= STATE_6;
    STATE_6         : #1 next_state <= STATE_7;
    STATE_7         : #1 next_state <= STATE_8;
    STATE_8         : #1 next_state <= STATE_9;
    
    STATE_9         : #1 next_state <= STATE_A;
    STATE_A         : #1 next_state <= STATE_B;
    STATE_B         : #1 next_state <= STATE_C;
    STATE_C         : #1 next_state <= STATE_D;
    
    STATE_D         : #1 next_state <= STATE_E;
    STATE_E         : #1 next_state <= STATE_F;
    STATE_F         : #1 next_state <= DECODE_ME;
    DECODE_ME       : 
      begin
      if (adj == 2'b 00)
        #1 next_state <= NORMAL_START;
      else if (adj == 2'b 01)
        #1 next_state <= LAG_START;
      else
        #1 next_state <= LEAD_START;
      end  
    default         : #1 next_state <= NORMAL_START;
  endcase
  
  case (state) 
    LEAD_START :
      begin
      i_wf_r <= 1'b 0;
      q_wf_r <= 1'b 1;
      sync_r <= 1'b 0;
      end
    NORMAL_START, 
    LAG_START, 
    STATE_3,
    STATE_4 :
      begin
      i_wf_r <= 1'b 1;
      q_wf_r <= 1'b 1;
      sync_r <= 1'b 0;
      end
    STATE_5, 
    STATE_6, 
    STATE_7, 
    STATE_8 :
      begin
      i_wf_r <= 1'b 1;
      q_wf_r <= 1'b 0;
      sync_r <= 1'b 0;
      end
    STATE_9, 
    STATE_A, 
    STATE_B, 
    STATE_C :
      begin
      i_wf_r <= 1'b 0;
      q_wf_r <= 1'b 0;
      sync_r <= 1'b 0;
      end
    STATE_D, 
    STATE_E, 
    STATE_F : 
      begin
      i_wf_r <= 1'b 0;
      q_wf_r <= 1'b 1;
      sync_r <= 1'b 0;
      end
    DECODE_ME :
      begin
      i_wf_r <= 1'b 0;
      q_wf_r <= 1'b 1;
      sync_r <= 1'b 1;
      end
    default :
      begin
      i_wf_r <= 1'b 0;
      q_wf_r <= 1'b 1;
      sync_r <= 1'b 0;
      end
  endcase
  end
  assign #1 i_wf = i_wf_r;
  assign #1 q_wf = q_wf_r;
  assign #1 sync = sync_r;
  
endmodule  //statecnt

////////////////////////////////////////////////////
// [EOF] statecnt.v



