function f=incantr_f(p,W)
% Subroutine for p1_3_16;                       5/98, 3/22/02
%
th=p(1); z=p(2); if z<=1, h=1-z/2; elseif z>1, h=1/(2*z); end 
f=(W/tan(th))+(1/(z*cos(th))); 

