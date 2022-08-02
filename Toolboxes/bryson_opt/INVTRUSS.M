function [f,g]=invtruss(p,W)
% Subroutine for Pb. 1.3.18; performance index f and constraints g(1)
% and g(2) for min weight inverted simple truss;       10/96, 5/13/98
%
th=p(1); b32=p(2); b52=p(3); f=2*W/sin(2*th)+2*b32+b52*tan(th);
if b32<6/pi^2, g(1)=W-(pi*b32)^2*sin(th)/6;
 else g(1)=W-2*b32*sin(th)+(6/pi^2)*sin(th); end
if b52<(6/pi^2)*(tan(th))^2, g(2)=W-(pi*b52)^2/(12*(tan(th))^2);
 else g(2)=W-b52+(3/pi^2)*(tan(th))^2; end

