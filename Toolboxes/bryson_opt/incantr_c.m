function [c,ceq]=incantr_c(p,W)
% Subroutine for p1_3_16;                       5/98, 3/22/02
%
th=p(1); z=p(2); if z<=1, h=1-z/2; elseif z>1, h=1/(2*z); end 
ceq=z*W-h*sin(th); c=[];

