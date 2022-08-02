%GAUSSQUADDEMO Demonstration of Gaussian quadrature formula.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-02-02 08:39:07 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

format long g
echo on
clc
%
%   Demonstration of Gaussian quadrature.
%
%   Approximate the integral of sin(x) from 0 to pi/2.
%   The exact solution is 1.
%
%   First, let us try with 2 base points.
%
[x, w] = gaussquad(2, 0, pi/2);
sum(w .* sin(x))

%   That was close, but still only 2 digits accuracy.
%
%   Press any key to continue...

pause

clc
%
%   Then, let us try with 4 base points.
%
[x, w] = gaussquad(4, 0, pi/2);
sum(w .* sin(x))

%   That was better. 7 digits accuracy.
%
%   Press any key to continue...

pause

clc
%
%   Finally, let us try with 6 base points.
%
[x, w] = gaussquad(6, 0, pi/2);
sum(w .* sin(x))

%   That was very good! 13 digits accuracy.

echo off
