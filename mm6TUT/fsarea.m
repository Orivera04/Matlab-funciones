function a=fsarea(kn,tmin,tmax,T)
%FSAREA Area Under Fourier Series. (MM)
% FSAREA(Kn,Tmin,Tmax,T) or FSAREA(Kn,[Tmin Tmax],T) returns
% the area under the function described by the Fourier series
% Kn having period T from Tmin to Tmax.
% If T is not given T=2*pi is assumed.
%
% See also FSHELP

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 9/17/99
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==2
   T=2*pi;
   tmax=tmin(2);
   tmin=tmin(1);
elseif nargin==3 & length(tmin)>1
   T=tmax;
   tmax=tmin(2);
   tmin=tmin(1);
elseif nargin==3
   T=2*pi;
elseif nargin~=4
   error('Incorrect Number of Input Arguments.')
end
kni=fsintgrl(kn);
a=diff(fseval(kni,[tmin tmax])) + fsharm(kn,0)*(tmax-tmin);