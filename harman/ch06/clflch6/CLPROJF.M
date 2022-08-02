function xdot = clprojf(t,x) 
% CALL: xdot = clprojf(t,x) to define equations of motion 
%   with drag for Example 6.10
%  x''=-drag*v*x'     x1=x, xdot1=x'=x3  xdot3=x''
%  y''=-drag*v*y'-g   x2=y, xdot2=y'=x4  xdot4=y''
% OUTPUT: xdot is column matrix of solutions for time point t
global drag g
V=sqrt(x(3)^2 + x(4)^2);  
xdot(1)=x(3);                 % represents x'
xdot(2)=x(4);                 % represents y'
xdot(3)=-drag*V*x(3);         % represents x''
xdot(4)=-drag*V*x(4)-g;       % represents y''
%
%  Modify the definition of xdot to change the system
%   equations

