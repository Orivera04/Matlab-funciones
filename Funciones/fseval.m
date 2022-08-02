function y=fseval(kn,t,T,flag)
%FSEVAL Fourier Series Function Evaluation. (MM)
% FSEVAL(Kn,t,T) computes values of a Real valued function given
% its complex exponential Fourier series coefficients Kn, at the
% points given in t where the period is T. If not given, T = 2*pi.
% K contains the Fourier coefficients in ascending order:
% Kn = [k   k     ... k  ...  k    k ]
%        -N  -N+1      0       N-1  N
% Note: this function creates a matrix of size:
% rows = length(t) and columns = (length(Kn)-1)/2
%
% FSEVAL(Kn,t,T,Flag) where Flag=1=TRUE forces FSEVAL to evaluate
% the Fourier Series term by term, which avoids creating the large
% matrix described above. This approach is slower, but dramatically
% reduces memory requirements. 
%
% See also FSHELP

% Calls: fssize

% D. Hanselman, University of Maine, Orono, ME  04469
% 2/9/95, revised 4/3/96 8/16/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin<4,  flag=0; end
if nargin==2, T=2*pi; end
wo=2*pi/T;
N=fssize(kn);		% highest harmonic
nwo=wo*(1:N);		% harmonic indices
ko=real(kn(N+1));	% average value

if flag  % slow, memory conservative way
   Ndc=N+1; % index of DC term
   y=ko+zeros(size(t));
   for m=1:N
      y=y+2*real(kn(Ndc+m)*exp(j*nwo(m)*t));
   end
   
else     % fast, memory intensive way
   kn=kn(N+2:2*N+1).';		% positive frequency coefs
   y=ko+2*(real(exp(j*t(:)*nwo)*kn))';
end
