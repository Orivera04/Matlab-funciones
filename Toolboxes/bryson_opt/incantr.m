function [f,g]=incantr(p,W)
% Subroutine for p1_3_16; min weight inverted cantilever truss using
% CONSTR; p=[th z];                                    5/98, 9/11/98
%
th=p(1); z=p(2); if z<=1, h=1-z/2; elseif z>1, h=1/(2*z); end 
f=(W/tan(th))+(1/(z*cos(th))); g=z*W-h*sin(th);

