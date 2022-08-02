function y2rot=vrot(xto_rot,theta_rot)
% CALL: y2rot=vrot(xto_rot,theta_rot)
%  Rotate the vector xto_rot by the angle theta_rot
%  x must be a 2 x 1 column vector, theta_rot in degrees.
theta_rot=theta_rot*pi/180;       % Convert to radians
Arot=[cos(theta_rot) -sin(theta_rot);sin(theta_rot) cos(theta_rot)];
y2rot=Arot*xto_rot;
