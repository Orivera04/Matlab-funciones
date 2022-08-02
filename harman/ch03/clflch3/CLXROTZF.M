function yh3rotz=clxrotzf(xto_rot,theta_rot)
% CALL: yh3rotz=clxrotzf(xto_rot,theta_rot)
%  Rotate the vector xto_rot by the angle theta_rot 
%    around the z axis
%  xto_rot must be a 4 x 1 column vector, theta_rot in degrees.
theta_rot=theta_rot*pi/180;       % Convert to radians
Arotz=[cos(theta_rot) -sin(theta_rot) 0 0;sin(theta_rot)...
 cos(theta_rot) 0 0
0 0 1 0;0 0 0 1];
yh3rotz=Arotz*xto_rot;

