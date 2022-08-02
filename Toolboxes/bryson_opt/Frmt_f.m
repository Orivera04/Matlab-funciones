function f=frmt_f(p,xf,yf)
% Subroutine for p4_3_04; min time to a point with V=1+y; 12/96, 6/25/98
%
th0=p(1); thf=p(2); x=(sin(th0)-sin(thf))/cos(th0); 
y=-1+cos(thf)/cos(th0); f=[x-xf  y-yf];


