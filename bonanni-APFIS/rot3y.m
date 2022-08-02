function R = rot3y(theta)

% ROT3Y - 3-space rotation matrix - y.
% R = rot3y(theta)
%
% Computes the 3x3 matrix representing a rotation 
% about the y-axis by angle 'theta'. 
%
% P.G. Bonanni
% 11/10/94


c = cos(theta);
s = sin(theta);
R = [c,0,s; 0,1,0; -s,0,c];
