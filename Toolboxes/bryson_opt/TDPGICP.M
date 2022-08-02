	function [Phi,Phis]=tdpgicp(t,y)
	% Subroutine for Pb. 3.6.8; TDP for max xf
	% with gravity and spec. yf; s=[u v x y]';
	% 			            4/1/97
	%
	Phi=[y(3); y(4)];
	Phis=[0 0 1 0; 0 0 0 1];
	  
	
	