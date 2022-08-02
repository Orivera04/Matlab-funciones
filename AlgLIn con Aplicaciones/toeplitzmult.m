%
% y=toeplitzmult(a,b,x)
%
% Computes y=toeplitz(a,b)*x, 
%
%   a   First column of the Toeplitz matrix (n by 1.)
%   b   First row of the Toeplitz matrix (1 by n.)
%   x   Vector to multiply the matrix times (n by 1.)
%   y   The product.
%
% Note that due to round-off errors, y might have a small imaginary
% component, even though a,b, and x are real.  To correct for this,
% simply use real(toeplitzmult(a,b,x));
%
% Note also that this code works correctly for complex Toeplitz
% matrices and vectors.
%
function y=toeplitzmult(a,b,x)
%
% The following code assumes that a is a column vector and b is a row
% vector.  If necessary, convert row vectors to column vectors and vice
% versa.
%
[m,n]=size(a);
if (n>m)
  a=a.';
end
[m,n]=size(b);
if (m>n)
  b=b.';
end
%
% Now do the multiplication.
%
n=length(a);
c=[a; 0; fliplr(b(2:end)).'];
p=ifft(fft(c).*fft([x; zeros(n,1)]));
y=p(1:n);
