	function [Phi,Phis]=tdpicp(t,y)
	% Subroutine for Pb. 3.6.5; TDP for max
	% xf with yf=0; s=[u v x y]';     4/1/97
	%
	Phi=[y(3); y(4)];
	Phis=[0 0 1 0; 0 0 0 1];
	  
	
	