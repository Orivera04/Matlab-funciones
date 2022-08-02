	function [Phi,Phis]=tdpcgp(t,y)
	% Subroutine for Pb. 3.6.9; TDP for max uf with
	% gravity & (vf,yf) specified; s=[u v y]';
	% 		 		   4/1/97
	%
	Phi=[y(1) y(2) y(3)-.2]';
	Phis=[1 0 0; 0 1 0; 0 0 1];
	
	