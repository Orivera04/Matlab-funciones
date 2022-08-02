function [x1,y1,z1] = rotate3z(x,y,z,theta)

% ROTATE3Z - Rotate a 3-space trajectory about the z-axis.
% [x1,y1,z1] = rotate3z(x,y,z,theta)
%
% Rotates the 3-space trajectory [x,y,z] by an amount 
% 'theta' radians about the z-axis, where 'theta' is 
% a vector equal in size to 'x', 'y', and 'z'.  Scalar 
% inputs are extended to vectors if needed. 
%
% P.G. Bonanni
% 3/5/96


% Determine vector length
N = max([length(x),length(y),length(z),length(theta)]);

% Unity vector
ONES = ones(N,1);

% Form vectors where needed
if size(x)==[1,1], x = x*ONES; end
if size(y)==[1,1], y = y*ONES; end
if size(z)==[1,1], z = z*ONES; end
if size(theta)==[1,1], theta = theta*ONES; end

% Perform rotation
sinO = sin(theta);
cosO = cos(theta);
x1 = x.*cosO - y.*sinO;
y1 = x.*sinO + y.*cosO;
z1 = z;
