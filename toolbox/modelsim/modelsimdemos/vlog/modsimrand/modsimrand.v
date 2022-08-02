//////////////////////////////////////////////////
// Psuedo Random Word Generator
// Demonstration of 'Link for ModelSim'     
//
//
//
//  Modelsim
// >vlog modsimrand.v
// >wrapverilog modsimrand
// >vsim work.modsimrand_wrap -foreign "matlabclient  matlablink.so;"
// >matlabtb modsimrand_wrap -rising /modsimrand_wrap/clk -socket 4448
// >force /modsimrand_wrap/clk 0 0,1 5 ns -repeat 10 ns
// >force /modsimrand_wrap/clk_en 1
// >force /modsimrand_wrap/reset 1 0,0 50 ns
// >run 50000
//
//  Copyright 2003-2004 The MathWorks, Inc.
//  $Revision: 1.1.6.2 $  $Date: 2004/04/08 20:55:14 $
//////////////////////////////////////////////////

//////////////////////////////////////////////////
// Entity: modsimrand
// Pseudo random algorithm
// Implements a uniform PN generator using 
// a fibonacci sequence.  
//////////////////////////////////////////////////

module modsimrand(clk, clk_en, reset, dout);
   
   input clk, clk_en, reset;
   output [31:0] dout;
   
   reg [31:0] 	 regfile [54:0];
   integer i;

   always @ (posedge clk)
     begin 
	if (clk_en == 1'b1) begin
    	   if (reset == 1'b1) begin
	      for (i=54;i>=0;i = i-1) 
		begin
		   regfile[i] <= 32'hffffffff;
		end
	   end
    	   else begin
	      for (i=54;i>=1;i = i-1)
		begin
		   regfile[i] <= regfile[i-1];
		end
	      regfile[0] <= regfile[54] + regfile[23];
	   end
	end 
     end // always @ (posedge clk)

   assign dout = regfile[0];

endmodule // modsimrand

////////////////////////////////////////////////////
// [EOF] modsimrand.vhd






