function xdot=p617f(t,x)
% P617f.m  Define the equations xdot=Ax+[0 1]'*f(t); % A=[0 1;-1 0]; 
% CALL: xdot=p617f(t,x) 
%
funct=1-(t^2)/(pi^2);
if t > pi
 funct=0;
end
xdot=[0 1;-1 0]*x + [0 1]'*funct;    % Column vector
%
% Version 5 Return a column vector