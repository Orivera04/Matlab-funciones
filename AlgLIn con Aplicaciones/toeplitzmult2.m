%
% y=toeplitzmult2(F,x)
%
% Computes y=toeplitz(a,b)*x, where F has been precomputed from a and b
% by F=toeplitzmultaux(a,b). 
%
%   F   A complex vector of length 2*n precomputed by toepliztmultaux(a,b) 
%   x   Vector to multiply the matrix times (must be n by 1.)
%   y   The product.
%
%
% Note that due to round-off errors, y might have a small imaginary
% component, even though a,b, and x are real.  To correct for this,
% simply use real(toeplitzmult(a,b,x));
%
% Note also that this code works correctly for complex Toeplitz
% matrices and vectors.
%
function y=toeplitzmult2(F,x)
%
% Now do the multiplication.
%
n=length(x);
p=ifft(F.*fft([x; zeros(n,1)]));
y=p(1:n);
