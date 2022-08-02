function n=fsindex(Kn)
%FSINDEX Harmonic Index Vector. (MM)
% FSINDEX(Kn) returns a row vector of harmonic indices
% based on the Fourier series vector Kn.
% For example if Kn has N nonnegative harmonics,
% FSINDEX returns -N:N
%
% See also FSHELP

% Calls: fssize

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 9/17/99
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

[N,msg]=fssize(Kn);
error(msg)
n=-N:N;