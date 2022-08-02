function [h,msg]=fssize(kn)
%FSSIZE Fourier Series Size. (MM)
% FSSIZE(Kn) returns the largest harmonic index N in the FS Kn.
% 
% [N,MSG]=FSSIZE(Kn) in addition returns a character string MSG where
% MSG='' if Kn is a valid FS vector or
% MSG='Kn is Not a Valid FS Vector.' if it is not.
% Therefore ERROR(MSG) can be used to return an error message.
%
% See also FSHELP.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 4/2/96, revised 11/14/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

msg=[];
h=(length(kn)-1)/2;
if h~=fix(h)
   if nargout>1, msg='Kn is Not a Valid FS Vector.';
   else,       error('Kn is Not a Valid FS Vector.');
   end
end
