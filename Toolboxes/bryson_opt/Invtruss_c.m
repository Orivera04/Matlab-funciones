function [c,ceq]=invtruss_c(p,W)
% Subroutine for Pb. 1.3.18; 10/96, 6/27/02
%
th=p(1); b32=p(2); b52=p(3); 
if b32<6/pi^2, ceq(1)=W-(pi*b32)^2*sin(th)/6;
 else ceq(1)=W-2*b32*sin(th)+(6/pi^2)*sin(th); end
if b52<(6/pi^2)*(tan(th))^2, ceq(2)=W-(pi*b52)^2/(12*(tan(th))^2);
 else ceq(2)=W-b52+(3/pi^2)*(tan(th))^2; end
c=[];
