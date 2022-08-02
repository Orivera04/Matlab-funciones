function angle1 = pvdegs(angle)

% PVDEGS - Symmetric principal value in degrees.
% angle1 = pvdegs(angle)
%
% This function converts angles outside the 
% range [-180,180] to their equivalent in that 
% range.  Both scalar and matrix inputs are 
% valid. 
%
% P.G. Bonanni
% 10/31/94


angle1 = angle - floor((angle+180)/360)*360;
