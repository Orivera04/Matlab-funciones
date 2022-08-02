function R = rot3x(theta)

% ROT3X - 3-space rotation matrix - x.
% R = rot3x(theta)
%
% Computes the 3x3 matrix representing a rotation 
% about the x-axis by angle 'theta'. 
%
% P.G. Bonanni
% 11/10/94


c = cos(theta);
s = sin(theta);
R = [1,0,0; 0,c,-s; 0,s,c];
