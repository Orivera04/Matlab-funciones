function xdot=cldesf(t,x,flag,A)
%  CALL: xdot=cldesf(t,x,flag,A) This function defines the equations 
%    xdot(t)=A*x(t) used by MATLAB commands ode23 and ode45.
%    A is passed to function; flag is a dummy variable
xdot=A*x;
%
% Example 5.18 defines the system
% xdot(1) = x(3);
% xdot(2) = x(4);
% xdot(3) = -2*x(1) + x(2);
% xdot(4) = x(1)-2*x(2);
% With the global statement any system xdot=A*x can be defined


