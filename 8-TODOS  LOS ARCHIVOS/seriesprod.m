function c=seriesprod(a,b);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% seriesprod.m
%
% Computes the expansion coefficients for the product of two power series
%
% sum_j c_j x^j = c(x)=a(x)*b(x) = (sum_j a_j x^j)*(sum_j b_j x^j)
%
% This can also done symbolicly with just one line of code
% 
% x=sym('x','real')
% sym2poly(poly2sym(a,x)*poly2sym(b,x))'
% 
% although this is typically hundreds of times slower.
%
% parameters:
% a, b - expansion coefficients in decending order of the series to be 
%        muliplied
% c    - expansion coefficients of the product (decending order)
%
% Written by Greg von Winckel - 07/05/2004
% Contact: gregvw@chtm.unm.edu
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

a=a(:);         b=b(:);
L=length(a);    M=length(b);
N=L+M-1;

a=a(L:-1:1);    b=b(M:-1:1);
c=toeplitz([a;zeros(M-1,1)],[a(1),zeros(1,N-1)])*[b;zeros(L-1,1)];
c=c(N:-1:1);

