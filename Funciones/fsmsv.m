function m=fsmsv(kn)
%FSMSV Fourier Series Mean Square Value. (MM)
% FSMSV(Kn) uses Parseval's theorem to compute the mean
% square value of a function given its FS coefficients Kn.
%
% See also FSHELP

% Calls fssize

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 1/12/95, revised 4/2/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

n=fssize(kn);
m=real(kn*kn');
