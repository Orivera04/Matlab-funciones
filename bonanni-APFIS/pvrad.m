function angle1 = pvrad(angle)

% PVRAD - Principal value in radians.
% angle1 = pvrad(angle)
%
% This function converts angles outside the 
% range [0,2*pi] to their equivalent in that 
% range.  Both scalar and matrix inputs are 
% valid. 
%
% P.G. Bonanni
% 11/10/94

twopi = 2*pi;
angle1 = angle - floor(angle/twopi)*twopi;
