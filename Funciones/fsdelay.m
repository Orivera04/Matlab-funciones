function k=fsdelay(kn,d)
%FSDELAY Add Time Delay to a Fourier Series. (MM)
% FSDELAY(Kn,D) produces a Fourier Series from the
% Fourier Series Kn, delayed by the normalized time
% delay in D.
% D = delay/period, D>0 delays, D<0 advances the signal.
%
% FSDELAY(Kn,'odd') delays the Fourier Series Kn so
% that the fundamental is a SINE wave.
% FSDELAY(Kn,'even') delays the Fourier Series Kn so
% that the fundamental is a COSINE wave.
%
% See also FSHELP

% Calls: fssize fsharm

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 4/1/96, last modified 5/29/96, v5: 1/14/97, 8/9/99
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==1, error('No Delay Chosen.'), end
nh=fssize(kn);
if ischar(d)  % odd or even chosen
   c=lower(d(isletter(d)));
   d=0;
   a=angle(fsharm(kn,1))/(2*pi); % angle of fundamental
   if c(1)=='o'
      d=a+1/4;
   elseif c(1)=='e'
      d=a;
   end
end
k=exp(-j*2*pi*(-nh:nh)*d).*kn;
