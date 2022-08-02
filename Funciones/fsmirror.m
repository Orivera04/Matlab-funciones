function kn=fsmirror(kn)
%FSMIRROR Fourier Series Time Mirror. (MM)
% FSMIRROR(Kn) returns a Fourier series vector that
% is the mirror image of Kn about the origin. That is,
% if Kn is the Fourier series of f(t), the result is
% the Fourier series of f(-t).
%
% See also FSHELP

% Calls: fssize

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 3/26/01
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

[N,msg]=fssize(kn);
error(msg)
kn=kn(end:-1:1);