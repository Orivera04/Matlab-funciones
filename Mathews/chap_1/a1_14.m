echo on; clc;
%---------------------------------------------------------------------------
%A1_14  MATLAB script file for investigating Theorem 1.14
%
% NUMERICAL METHODS: MATLAB Programs, (c) John H. Mathews 1995
% To accompany the text:
% NUMERICAL METHODS for Mathematics, Science and Engineering, 2nd Ed, 1992
% Prentice Hall, Englewood Cliffs, New Jersey, 07632, U.S.A.
% Prentice Hall, Inc.; USA, Canada, Mexico ISBN 0-13-624990-6
% Prentice Hall, International Editions:   ISBN 0-13-625047-5
% This free software is compliments of the author.
% E-mail address:       in%"mathews@fullerton.edu"
%
% Theorem 1.14  (Horner's Method for Polynomial Evaluation).
% Section 1.1,   Review of Calculus, Page 12
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Theorem 1.14  (Horner's Method for Polynomial Evaluation).
%                       n        n-1          2           0
% Assume that P(x) = a x  + a   x    +...+ a x  + a x  + a .
%                     n      n-1            2      1      0
%
% Then P(x) can be computed recursively as follows:
%
% Set b  = a , and b  = a  + x b     for  k=n-1,n-2,...,0
%      n    n       k    k      k+1
%
% Then  P(x) = b .
%               0
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Example on page 13.  Use Horner's method to evaluate  P(3)
%
% where  P(x) = x^5 - 6x^4 + 8x^3 + 8x^2 + 4x - 40
%
% First, find Horner's nested form of the polynomial.

p = 'x^5 - 6*x^4 + 8*x^3 + 8*x^2 + 4*x - 40';

q = horner(p)

pause % Press any key to continue.

clc;
%
% The list of coefficients for the polynomial is:
%

c = [1  -6  8  8  4 -40];

% The polynomial can also be evaluated using the Matlab
%
% procedure  polyval(c,x).
%
% Verify the computations for the three polynomal forms.


pause % Press any key to continue.

clc;

x = 3;

polyval(c,x)
eval(p)
eval(q)

pause % Press any key to continue.

clc;

% Consider the computational time for vector arguments.
c = [1  -6  8  8  4 -40];
p = 'x.^5 - 6*x.^4 + 8*x.^3 + 8*x.^2 + 4*x - 40';
q = '-40+(4+(8+(8+(-6+x).*x).*x).*x).*x';
x = 1:1:900;
%
% Remark. It might be interesting to perform the
% computations several times and see the different
% results.
%
t0 = clock; v0 = polyval(c,x); t0 = etime(clock,t0);
t1 = clock; v1 = eval(p); t1 = etime(clock,t1);
t2 = clock; v2 = eval(q); t2 = etime(clock,t2);
[t0; t1; t2]


