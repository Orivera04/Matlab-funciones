function a = sincof(func,hafper,nft)
%
% a = sincof(func,hafper,nft)
%
% This function calculates the sine coefficients.
%
% func    - the name of a function defined over a half period
% hafper  - the length of the half period of the function
% nft     - the number of function values used in the Fourier series
% a       - the vector of Fourier sine series coefficients
%
% User m functions required: none
%--------------------------------------------------------------

n2 = nft/2;
x = hafper/n2*(0:n2);
y = feval(func,x);
y = y(:);
a = fft([y;-y(n2:-1:2)]);
a = -imag(a(2:n2))/n2;
