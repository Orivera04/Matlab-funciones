function ti=fsinterp(kn,val,T)
%FSINTERP Inverse Interpolate Fourier Series. (MM)
% FSINTERP(Kn,Val,T) returns the time points where the function f(t)
% described by the Fourier Series Kn has the scalar value Val. The
% returned time points are in the range [0,T) where T is the period.
% If not given, T=2*pi.
%
% Solution approximated by Fourier series evaluation and linear
% interpolation. Absolute error is typically less than 1e-8.
% Beware of multiple solutions around zero slope areas in f(t).
%
% See also FSHELP

% Calls: fssize, fseval, mmsearch

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 2/14/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==2
   T=2*pi;
elseif nargin~=3
   error('Two or Three Input Arguments Required.')
end
if prod(size(val))~=1
   error('Val Must be a Scalar.')
end
N=11*fssize(kn);        % evaluate highest harmonic 11 times per period
t=linspace(0,T,N)';     % where to evaluate
t=t-(t(2)-t(1));        % shift to capture 0 and avoid T
f=fseval(kn,t,T);       % evaluate FS
below=(f<=val);
above=~below;
idx=find((below(1:end-1)&above(2:end))|(below(2:end)&above(1:end-1)));
lidx=length(idx);
if isempty(idx)   % no solutions
   ti=[];
else              % zoom in to find approximate solution
   ti=zeros(lidx,1);
   for i=1:lidx
      tt=linspace(t(idx(i)),t(idx(i)+1))';
      ff=fseval(kn,tt,T);
      ti(i)=mmsearch(ff,tt,val);
   end
end
