function k=fsangle(kn,fn,n)
%FSANGLE Angle Between Two Fourier Series. (MM)
% A=FSANGLE(Kn,Fn,N) returns the angle A in radians between
% the (N)th harmonic component of Kn and Fn.
% If N is not given, N=+1 is assumed.
%
% The angle A is angle(Kn)-angle(Fn), i.e.,
% A is Positive if Kn LEADS Fn.
% Delaying Kn by the A/(2*pi) aligns the (N)th harmonic
% components of both Fourier series.
%
% See also FSHELP 

% Calls: fsharm

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 5/28/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==2, n=1; end
k=angle(fsharm(kn,n))-angle(fsharm(fn,n));
