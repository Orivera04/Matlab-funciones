function [fm,tm]=fspeak(kn,Tspan,T)
%FSPEAK Fourier Series Peak Value. (MM)
% [F,Tp]=FSPEAK(Kn,Tspan,T) returns the peak value F of the function
% described by the Fourier Series Kn and the point Tp where it occurs.
% Tspan=[Tmin Tmax] is the range to search for the peak.
% If empty or not given, Tspan=[0 T].
% T is the period of the waveform. If T is not given, T=2*pi is assumed.
%
% Solution approximated by Fourier Series evaluation. Error typically
% less than 1e-7. Beware of Fourier series that exhibit Gibb's phenomenon.
%
% See also FSHELP

% Calls: fssize, fseval mmempty

% D.C. Hanselman, University of Maine, Orono, ME 04469
% v5: 2/10/97, 4/9/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

N=11*fssize(kn);  % evaluate highest harmonic 11 times per period
if     nargin==1,  T=2*pi; Tspan=[0 T];
elseif nargin==2,  T=2*pi;
end
Tspan=mmempty(Tspan,[0 T]);

ti=linspace(Tspan(1),Tspan(2),N);
f=fseval(kn,ti,T);
[fm,i]=max(f);
if i==1      % max is at first point, look before first point
   Tspan=[2*ti(1)-ti(2) ti(2)];
elseif i==N  % max is at last point, look past last point
   Tspan=[ti(N) 2*ti(N)-ti(N-1)];
else		 % look around point
   Tspan=[ti(i-1) ti(i+1)];
end
ti=linspace(Tspan(1),Tspan(2),N);  % evaluate on a finer scale
f=fseval(kn,ti,T);
[fm,i]=max(f);
tm=ti(i);
