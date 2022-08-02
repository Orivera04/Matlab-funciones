echo on; clc;
%---------------------------------------------------------------------------
%A1_12   MATLAB script file for investigating Theorem 1.12
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
% Theorem 1.12  (Weighted Integral Mean Value Theorem).
% Section 1.1,   Review of Calculus, Page 8
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Theorem 1.12  (Weighted Integral Mean Value Theorem).
%
% Assume that both  f  and   g  are continuous over [a,b],
%
% and that  0 <= g(x)  for a <= x <= b.
%
% Then there exists a number c, with a < c < b, such that
%
%        b                      b
%        /                      /
%        | f(x)g(x) dx  =  f(c) | g(x) dx.
%        /                      /
%        a                      a
%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example for page 8.  Let  f(x) = x^2  and  g(x) = 1 + sin(x)
%
% and let [a, b] = [0, 3pi/2].  find the value  c  so that
%
%   3pi/2                   3pi/2
%     /                       /
%     |  f(x)g(x)dx  =  f(c)  |  g(x)dx
%     /                       /
%     0                       0 
%

pause % Press any key to continue.

clc;

f = 'x^2';

g = '1 + sin(x)';

h  = symmul(f,g)
L  = int(h,'x',0,3*pi/2)
L  = -3*pi+9/8*pi^3-2
R  = int(g,'x',0,3*pi/2)
R  = 3/2*pi+1
fc = L/R
c  = sqrt(fc)

clc;

M1 = '  3pi/2                   3pi/2';
Mu = '    /                       /';
M2 = '    |  f(x)g(x)dx  =  f(c)  |  g(x)dx';
Md = '    /                       /';
M3 = '    0                       0 ';
M4 = 'The value  c  and  f(c)  are given by:';
M5 = 'Computations for the left and right side are:';
clc;
disp(' ');disp(' ');disp(M1);disp(' ');disp(Mu);...
disp(' ');disp(M2);disp(' ');disp(Md);...
disp(M3);disp(' ');disp(M4);disp(' ');...
disp(['c =  ',num2str(c)]);disp(' ');...
disp(['f(c) =  ',num2str(fc)]);disp(' ');disp(M5);...
disp(' ');disp([num2str(L),' = ',num2str(fc),'*',num2str(R)]);

