function fn=fsselect(kn,n)
%FSSELECT Fourier Series Harmonic Selection. (MM)
% FSSELECT(Kn,N) returns a Fourier series vector the same
% size as Kn, containing only the harmonics selected by
% the index vector N. All other harmonics are set to zero.
%
% Symmetry is enforced in N. That is if a harmonic index n
% appears in N, -n is added if it is not present. Indices
% outside the range contained in Kn are ignored.
%
% For example:
% FSSELECT(Kn,[0:4 -8]) creates a Fourier series vector
% the same size as Kn, containing the values of Kn at the
% harmonics -8,-4,-3,-2,-1,0, 1, 2, 3, 4, 8
%
% See also FSHELP

% Calls: fssize

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 5/5/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin~=2
   error('Two Input Arguments Expected.')
end
[N,msg]=fssize(kn);
error(msg)

fn=zeros(size(kn));        % default output
n=unique(abs(n));          % get unique non-negative indices
n(n>N)=[];                 % throw out indices outside of kn
if any(n~=fix(n))
   error('N Must Contain Integer Harmonic Indices.')
end
ndc=N+1;                   % vector index of DC component
n=ndc+sort([n -n(n>0)]);   % indices to grab from kn

fn(n)=kn(n);
