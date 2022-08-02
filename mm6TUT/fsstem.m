function h=fsstem(kn,varargin)
%FSSTEM Fourier Series Line Spectra Plot. (MM)
% FSSTEM(Kn,Nmin,Nmax) creates a stem plot of the amplitude of the
% Fourier series coefficients Kn, starting at harmonic Nmin and ending
% at harmonic Nmax.
% FSSTEM(Kn) considers all nonnegative harmonics.
% FSSTEM({Kn1 Kn2 ...},...) plots each Fourier series in the
% initial input cell array.
% H=FSSTEM(...) returns the handles to the lines and markers.
%
% See also FSHELP

% Calls: fssize, fsharm

% D. Hanselman, University of Maine, Orono, ME  04469
% 8/9/99
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if iscell(kn) % cell array input
   lkn=length(kn);
   Nn=zeros(1,length(kn));
   for i=1:lkn
      Nn(i)=fssize(kn{i});
   end
   N=max(Nn);
   if nargin==1
      nmin=0; nmax=N;
   else
      nmin=varargin{1}; nmax=varargin{2};
   end
   n=max(min(nmin,nmax),-N):min(max(nmin,nmax),N);
   y=zeros(length(n),lkn);
   for i=1:lkn
      knn=fsresize(kn{i},max(abs(n(1)),abs(n(end))));
      y(:,i)=abs(fsharm(knn,n))';
   end
else
   [N,msg]=fssize(kn);
   error(msg)
   if nargin==1
      nmin=0; nmax=N;
   else
      nmin=varargin{1}; nmax=varargin{2};
   end
   n=max(min(nmin,nmax),-N):min(max(nmin,nmax),N);
   y=abs(fsharm(kn,n));
end
if nargout==1
   h=stem(n,y);
else
   stem(n,y)
end
