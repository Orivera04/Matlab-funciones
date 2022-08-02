function [z,a,b]=squarat(zeta,ifout)
% 
% [z,a,b]=squarat(zeta,ifout)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function maps either the interior of a 
% circle onto the interior of a square, or maps 
% the exterior of a circle onto the exterior of 
% a square using a rational function having the 
% approximate form:
%
%  z(zeta) = zeta * 
%
%      Sum(a(j)*zeta4^j)/(1+Sum(b(j)*zeta4^j),
%
% where zeta4=zeta^4 for an interior problem,
% or zeta4=zeta^(-4) for an exterior problem.
%
% zeta  - matrix of complex values such that 
%         abs(zeta)<=1 for an interior map, 
%         or abs(zeta)>=1 for an exterior map
% ifout - parameter present in the call list 
%         only when an exterior mapping is 
%         required
%
% z     - matrix of values of the mapping 
%         function
% a,b   - coefficients of the polynomials
%         defining the rational mapping 
%         function
%
% User m functions called: none
%----------------------------------------------

zeta4=zeta.^4;

if nargin==1 % map interior on interior
  a=[ 1.07835, 1.37751,-0.02642, -0.09129, ...
      0.13460,-0.15763, 0.07430,  0.14858, ...
      0.01878,-0.00354 ]'; 
  b=[ 1.37743, 0.07157,-0.11085,  0.12778, ...
     -0.13750, 0.05313, 0.14931,  0.02683, ...
     -0.00350,-0.000120 ]';
else         % map exterior on exterior
  a = [1.18038, 1.10892, 0.13365, -0.02910]';
  b = [1.10612, 0.27972, 0.00788]'; 
  zeta4=1./zeta4; 
end

% Evaluate the mapping function 
af=flipud(a); bf=flipud([1;b]);
z=zeta.*polyval(af,zeta4)./polyval(bf,zeta4);
