	function [Phi,Phis]=tdpcgxp(t,y)
	% Subroutine for Pb. 3.6.10; TDP for max uf
	% with gravity & (vf,yf,xf) specified;
	% s=[u v y x]';	 		  4/1/97
	%
	Phi=[y(1); y(2); y(3)-.2; y(4)-.15];
	Phis=[1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
	  
	
	