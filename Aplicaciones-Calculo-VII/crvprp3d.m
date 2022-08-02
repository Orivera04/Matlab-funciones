function [T,N,B,kap,tau]=crvprp3d(R1,R2,R3)
%
% [T,N,B,kap,tau]=crvprp3d(R1,R2,R3)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function computes the primary 
% differential properties of a three-dimensional 
% curve parameterized in the form R(t) where t 
% can be arc length or any other convenient 
% parameter such as time.
%
% R1  - the matrix with columns containing R'(t)
% R2  - the matrix with columns containing R''(t)
% R3  - the matrix with columns containing 
%       R'''(t).  This matrix is only needed 
%       when torsion is to be computed.
%
% T   - matrix with columns containin the 
%       unit tangent
% N   - matrix with columns containing the 
%       principal normal vector
% B   - matrix with columns containing the 
%       binormal
% kap - vector of curvature values
% tau - vector of torsion values. This equals 
%       [] when R3 is not given 
%
% User m functions called:  none
%----------------------------------------------

nr1=sqrt(dot(R1,R1)); T=R1./nr1(ones(3,1),:);
R12=cross(R1,R2); nr12=sqrt(dot(R12,R12));
B=R12./nr12(ones(3,1),:); N=cross(B,T); 
kap=nr12./nr1.^3;

% Compute the torsion only when R'''(t) is given
if nargin==3,   tau=dot(B,R3)./nr12; 
else, tau=[]; end