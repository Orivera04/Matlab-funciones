function R = rot3z(theta)

% ROT3Z - 3-space rotation matrix - z.
% R = rot3z(theta)
%
% Computes the 3x3 matrix representing a rotation 
% about the z-axis by angle 'theta'. 
%
% P.G. Bonanni
% 11/10/94


c = cos(theta);
s = sin(theta);
R = [c,-s,0; s,c,0; 0,0,1];
