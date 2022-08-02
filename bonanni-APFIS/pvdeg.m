function angle1 = pvdeg(angle)

% PVDEG - Principal value in degrees.
% angle1 = pvdeg(angle)
%
% This function converts angles outside the 
% range [0,360] to their equivalent in that 
% range.  Both scalar and matrix inputs are 
% valid. 
%
% P.G. Bonanni
% 10/31/94

angle1 = angle - floor(angle/360)*360;
