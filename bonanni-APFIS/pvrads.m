function angle1 = pvrads(angle)

% PVRADS - Symmetric principal value in radians.
% angle1 = pvrads(angle)
%
% This function converts angles outside the 
% range [-pi,pi] to their equivalent in that 
% range.  Both scalar and matrix inputs are 
% valid. 
%
% P.G. Bonanni
% 11/10/94


twopi = 2*pi;
angle1 = angle - floor((angle+pi)/twopi)*twopi;
