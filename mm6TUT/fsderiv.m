function dk=fsderiv(kn,T)
%FSDERIV Fourier Series Derivative. (MM)
% FSDERIV(Kn,T) returns the FS coeficients of the derivative
% of f(t) whose FS coeficients are given by Kn and whose
% fundamental period is T.
% If T is not given, T=2*pi is assumed.
%
% See also FSHELP

% Calls: fssize

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 1/12/95, revised 8/12/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==1, T=2*pi; end
n=fssize(kn);        % number of harmonics
dk=(2*pi/T)*sqrt(-1)*(-n:n).*kn; % jn*Wo*Kn is derivative
