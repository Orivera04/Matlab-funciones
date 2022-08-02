function ydot=vdpol(t,y,mu)
%VDPOL van der Pol equation.
% Ydot=VDPOL(t,Y)
% Ydot(1) = Y(2)
% Ydot(2) = mu*(1-Y(1)^2)*Y(2)-Y(1)
% mu = 2

% mu = ?; now passed as an input argument

if nargin < 3 % supply default if not given
   mu=2;
end
%ydot = [y(2,:); mu*(1-y(1,:)^2)*y(2,:)-y(1,:)];
ydot = [y(2); mu*(1-y(1)^2)*y(2)-y(1)];