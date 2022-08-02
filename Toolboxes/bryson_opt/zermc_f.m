function f=zermc_f(p,tf,yf)
% Subroutine for Pb. 3.3.2; VDP for max range with V=Vo*y/h with yf
% specified; plots from analytical soln; p=[th0,thf];   12/96, 6/11/98
%
th0=p(1); thf=p(2); f=[tf+tan(thf)-tan(th0) yf+1/cos(thf)-1/cos(th0)];

	
	