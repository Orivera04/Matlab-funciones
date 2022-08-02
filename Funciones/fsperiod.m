function k=fsperiod(kn,N)
%FSPERIOD Change Fourier Series Period. (MM)
% FSPERIOD(Kn,N) where N is a positive integer, increases
% the period of the Fourier Series Kn by N. The i-th harmonic
% of the input becomes the (N*i)-th harmonic of the output FS.
% The output FS contains N*FSSIZE(Kn) harmonics.
%
% FSPERIOD(Kn,N) where N is a negative integer, decreases the 
% period of the FS Kn by N. The (N*i)-th harmonic of the input
% becomes the i-th harmonic of the output FS. All other harmonics
% in the input FS are ignored.
%
% See also FSHELP.

% Calls: fssize

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 11/10/99
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin~=2
   error('Two Input Arguments Are Required.')
end
if length(N(:))~=1 | fix(N)~=N
   error('N Must be a Scalar Integer.')
end
[n,msg]=fssize(kn);
error(msg)
if N>0 % increase
   nn=2*n*N+1;
   k=zeros(1,nn);
   idx=(1:nn);
   k(idx(1:N:end))=kn;
elseif N<0 % decrease
   N=abs(N);
   if N>n % only DC term!
      k=kn(n+1);
   else 
      idx=(-n:n)/abs(N);
      k=kn(idx==fix(idx));
   end
else % no change
   k=kn;
end