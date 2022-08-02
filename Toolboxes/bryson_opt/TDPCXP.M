	function [Phi,Phis]=tdpcxp(t,y)
	% Subroutine for Pb. 3.6.7; TDP for max uf
	% and (vf,yf,xf) specified; s=[u v y x]';
	% 		 		  4/1/97
	%
	Phi=[y(1) y(2) y(3)-.2 y(4)-.2]';
	Phis=[1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
	  
	
	