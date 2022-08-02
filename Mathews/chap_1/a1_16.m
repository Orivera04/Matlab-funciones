echo on; clc;
%---------------------------------------------------------------------------
%A1_16  MATLAB script file for investigating Theorem 1.16
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
% Theorem 1.16  (Big "O" remainders for Taylor's Theorem).
% Section 1.2,   Binary Numbers, Page 33
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Theorem 1.16  (Big "O" remainders).  Assume that
%                  n                     m
% f(h) = p(h) + O(h ),  f(h) = q(h) + O(h )  and  p = min{m,n}.
%
%                                        p
% Then  f(h) + g(h)  =  p(h) + q(h) + O(h ),
%
%                                      p
%         f(h) g(h)  =  p(h) q(h) + O(h ),
%
%                                      p
%         f(h)/g(h)  =  p(h)/q(h) + O(h ).
%
%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 1.11, page 34
%
% First find Taylor expansions for exp(h) and cos(h):
taylor('exp(h)','h',4)
taylor('cos(h)','h',6)
pause % Press any key to continue.

clc;

s1 = taylor('exp(h)+cos(h)','h',4);
t1 = ['exp(h)+cos(h) = ' s1];
s2 = taylor('exp(h)+cos(h)','h',5);
t2 = ['exp(h)+cos(h) = ' s2];
s3 = expand('(1+1*h+1/2*h^2+1/6*h^3)+(1-1/2*h^2+1/24*h^4)');
t3 = ['exp(h)+cos(h) = ' s3];
s4 = taylor('exp(h)+cos(h)-(1+1*h+1/2*h^2+1/6*h^3)-(1-1/2*h^2+1/24*h^4)','h',5);
t4 = 'exp(h)+cos(h)-(1+1*h+1/2*h^2+1/6*h^3)-(1-1/2*h^2+1/24*h^4) = ';

clc;

M1 = 'Consider the Taylor expansion for the sum exp(h)+cos(h).';
M2 = 'The following expansions will differ in the term involving  h^4';
M3 = 'Which can also be seen by looking carefully at the expansion:';
clc; disp(' ');disp(' ');disp(' ');disp(' ');...
disp(M1);disp(' ');disp(t1);disp(' ');...
disp(M2);disp(' ');disp(t2);disp(t3);disp(' ');...
disp(M3);disp(' ');disp(t4);disp(' ');disp(s4);disp(' ');

pause % Press any key to continue.

clc;

s5 = taylor('exp(h)*cos(h)','h',4);
t5 = ['exp(h)*cos(h) = ' s5];
s6 = taylor('exp(h)*cos(h)','h',5);
t6 = ['exp(h)*cos(h) = ' s6];
s7 = expand('(1+1*h+1/2*h^2+1/6*h^3)*(1-1/2*h^2+1/24*h^4)');
t7 = ['exp(h)*cos(h) = ' s7];
s8 = taylor('exp(h)*cos(h)-(1+1*h+1/2*h^2+1/6*h^3)*(1-1/2*h^2+1/24*h^4)','h',5);
t8 = 'exp(h)*cos(h)-(1+1*h+1/2*h^2+1/6*h^3)*(1-1/2*h^2+1/24*h^4) = ';

clc;

M1 = 'Consider the Taylor expansion for the product exp(h)*cos(h).';
M2 = 'The following expansions will differ in the term involving  h^4';
M3 = 'Which can also be seen by looking carefully at the expansion:';
clc; disp(' ');disp(' ');disp(' ');disp(' ');...
disp(M1);disp(' ');disp(t5);disp(' ');;...
disp(M2);disp(' ');disp(t6);disp(t7);disp(' ');...
disp(M3);disp(' ');disp(t8);disp(' ');disp(s8);disp(' ');

