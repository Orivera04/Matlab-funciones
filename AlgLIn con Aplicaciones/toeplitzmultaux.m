%
% F=toeplitzmultaux(a,b)
%
% Precomputes data for fast multiplication of y=toeplitz(a,b)*x by the
% toeplitzmult2() function, 
%
%   a   First column of the Toeplitz matrix (n by 1.)
%   b   First row of the Toeplitz matrix (1 by n.)
%   F   A complex vector of length 2*n used by toeplitzmult2()
%
function F=toeplitzmultaux(a,b)
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
F=fft(c);
