function dk=fsintgrl(kn,T)
%FSINTGRL Fourier Series Integral. (MM)
% FSINTGRL(Kn,T) returns the FS coeficients of the integral
% of f(t) whose FS coeficients are given by Kn and whose
% fundamental period is T. The integral returned is zero at t=0.
% The average or DC value of f(t) is ignored.
% If T is not given, T=2*pi is assumed.
%
% See also FSHELP

% Calls: fsindex

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 8/11/96, v5: 1/14/97, 9/17/99
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==1, T=2*pi; end
wo=2*pi/T;
n=fsindex(kn);
i=find(n);
dk=zeros(size(kn));
dk(i)=kn(i)./(n(i)*wo*sqrt(-1)); % Kn/(jn*wo) is integral
dk(n(end)+1)=-real(sum(dk(i)));