function J=jnft(n,z,nft)
%
% J=jnft(n,z,nft)
% ~~~~~~~~~~~~~~~~~~~~~
% Integer order Bessel functions of the 
% first kind computed by use of the Fast 
% Fourier Transform (FFT).
%
% n   - integer vector defining the function 
%       orders
% z   - a vector of values defining the 
%       arguments
% nft - number of function evaluations used 
%       in the FFT calculation. This value 
%       should be an integer power of 2 and 
%       should exceed twice the largest 
%       component of n. When nft is omitted 
%       from the argument list, then a value 
%       equal to 512 is used. More accurate 
%       values of J are computed as nft is 
%       increased. For max(n) < 30 and 
%       max(z) < 30, nft=256 gives about 
%       ten digit accuracy.
% J   - a matrix of values for the integer 
%       order Bessel function of the first 
%       kind. Row position matches orders 
%       defined by n, and column position 
%       corresponds to arguments defined by 
%       components of z.
%
% User m functions called:  none.
%----------------------------------------------

if nargin<3, nft=512; end;
J=exp(sin((0:nft-1)'* ...
  (2*pi/nft))*(i*z(:).'))/nft;
J=fft(J); J=J(1+n,:).';
if sum(abs(imag(z)))<max(abs(z))/1e10
  J=real(J); 
end 