function Fn=fsabs(kn)
%FSABS Fourier Series Absolute Value. (MM)
% FSABS(Kn) returns the Fourier Series vector of the absolute value
% of the input Fourier Series Kn. The output vector is the same size
% as that of the input.
%
% See also FSHELP

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 9/25/01
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

[N,msg]=fssize(kn);
error(msg)

n=2*N;
t=linspace(0,1,n+1);
t(end)=[];
f=abs(fseval(kn,t,1));
Fn=fft(f);
Fn=Fn(1:N+1)/n;
Fn=[conj(Fn(N+1:-1:2)) Fn];
Fn(N+1)=real(Fn(N+1)); % DC term is real for real functions
