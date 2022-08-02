function [c,ceq]=cantruss_c(p,W)
% Subroutine for Pb. 1.3.15;   5/98, 3/22/02
%
th=p(1); z=p(2); 
if z<=1, h=1-z/2; elseif z>1, h=1/(2*z); end
ceq=z*W-h*tan(th); c=[];
