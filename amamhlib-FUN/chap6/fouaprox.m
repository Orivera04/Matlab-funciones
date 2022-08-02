function y=fouaprox(func,per,t,nsum,nft)
% 
% y=fouaprox(func,per,t,nsum,nft)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Approximation of a function by a Fourier 
% series.
%
% func   - function being expanded
% per    - period of the function
% t      - vector of times at which the series
%          is to be evaluated
% nsum   - number of terms summed in the series
% nft    - number of function values used to 
%          compute Fourier coefficients. This 
%          should be an integer power of 2. 
%          The default is 1024
%
% User m functions called:  none.
%----------------------------------------------

if nargin<5, nft=1024; end; 
nsum=min(nsum,fix(nft/2));
c=fft(feval(func,per/nft*(0:nft-1)))/nft; 
c(1)=c(1)/2; c=c(:); c=c(1:nsum); 
w=2*pi/per*(0:nsum-1); 
y=2*real(exp(i*t(:)*w)*c);