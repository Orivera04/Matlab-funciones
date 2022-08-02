function p = tch(C,n,x,a,b)
%---------------------------------------------------------------------------
%TCH   Evaluation of the Chebyshev polynomial.
% Sample calls
%   p = tch(C,n,x)
%   p = tch(C,n,x,a,b)
% Inputs
%   C   coefficient list for Chebyshev polynomial
%   n   degree of the Chebyshev polynomial
%   x   independent variable value(s) for evaluation
%   a   left  endpoint of interval
%   b   right endpoint of interval
% Return
%   p   function value(s)
%
% NUMERICAL METHODS: MATLAB Programs, (c) John H. Mathews 1995
% To accompany the text:
% NUMERICAL METHODS for Mathematics, Science and Engineering, 2nd Ed, 1992
% Prentice Hall, Englewood Cliffs, New Jersey, 07632, U.S.A.
% Prentice Hall, Inc.; USA, Canada, Mexico ISBN 0-13-624990-6
% Prentice Hall, International Editions:   ISBN 0-13-625047-5
% This free software is compliments of the author.
% E-mail address:      in%"mathews@fullerton.edu"
%
% Algorithm 4.6 (Chebyshev Approximation).
% Section	4.5, Chebyshev Polynomials, Page 246
%---------------------------------------------------------------------------

if nargin==3, a=-1; b=1; end
x = 2*(x-a)/(b-a) - 1;
T0 = ones(1,length(x));
p = C(1)*T0;
if n==0, return, end
T1 = x;
p = p + C(2)*T1;
if n==1, return, end
for j=3:n+1,
  Tj = 2*x.*T1 - T0;
  p  = p + C(j)*Tj;
  T0 = T1;
  T1 = Tj;
end

