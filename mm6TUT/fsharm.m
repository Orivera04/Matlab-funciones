function [h,ih]=fsharm(kn,n)
%FSHARM Fourier Series Harmonic Component Selection. (MM)
% FSHARM(Kn,N) returns the Fourier series components of Kn
% at the harmonic indices given in N. Values in N that are
% outside the range in Kn are discarded.
%
% FSHARM(Kn) returns the DC component only.
% [H,I]=FSHARM(...) returns a vector index of the selected
% harmonics H in the vector I, i.e., H=Kn(I).
%
% Note that this function returns the selected values in an
% array not as a Fourier series vector. See FSSELECT to
% extract harmonics from one Fourier series to create another.
%
% See also FSHELP

% Calls: fssize

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 1/12/95 revised 4/10/96 8/16/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

N=fssize(kn);   % number of positive harmonics
ndc=N+1; % index of DC term
if nargin==1, n=0; end
n=fix(n(:).'); % make sure indices are integers
n(abs(n)>N)=[]; % throw out harmonics outside range
ih=ndc+n;       % vector index of desired harmonics
h=kn(ih);
