echo on; clc;
%---------------------------------------------------------------------------
%A1_17  MATLAB script file for investigating Theorem 1.17
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
% Theorem 1.17  (Remainder term for Taylor's Theorem).
% Section 1.2,   Error Analysis, Page 34
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Theorem 1.17  (Remainder term for Taylor's Theorem).  Assume
%                                                    (n)
% that  f(x)  and its derivatives  f'(x),f''(x),...,f   (x)  are
%
% are all continuous on [a,b].  If both  x   and x = x  + h
%                                         0           0
% lie in the interval [a,b],  then
%
%                             n
%         f(x)  =  P (x) + O(h ),  where
%                   n
%
% P (x)  is the n-th degree Taylor polynomial expanded about x .
%  n                                                          0
%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example for page 34.  Consider  f(x) = sin(x)  and the Taylor
%
% polynomials of degree  n = 3, 5 and 7  expanded about x  = 0:
%                                                        0
% n-th degree Taylor polynomial             Order of the approximation
%
%              3
% P (x) = x - x /6                          x^5/120 = O(x^5)
%  3
%              3      5
% P (x) = x - x /6 + x /120                 x^7/5040 = O(x^7)
%  5
%              3      5        7
% P (x) = x - x /6 + x /120 - x /5040       x^9/362880 = O(x^9)
%  7

pause % Press any key to continue.

clc;

% (i)   Show that  |sin(x) - P (x)| <= |x^5/120|  over [-1,1].
%                             3
%       REMARK. The factor 1.04 was added to separate the curves.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays to plot y = f(x).
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = -1;
b =  1;
F = 'sin(X)-(X-1/6*X.^3)';
G = '1.04*X.^5/120';
h = (b-a)/100;
X = a:h:b;
Y = eval(F);
Z = eval(G);

clc; figure(1); clg;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = -1;
b =  1;
c = -1/120;
d =  1/120;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
title('The error bound  |sin(x) - P3(x)| <= |x^5/120|  over [-1,1]'); figure(gcf);
% fplot(' 1.04*x^5/120',[-1 1],'-g'); figure(gcf);
% fplot('-1.04*x^5/120',[-1 1],'-g'); figure(gcf);
plot(X,Z,'-g',X,-Z,'-g'); figure(gcf);
% fplot('sin(x)-(x-1/6*x^3)',[-1 1],'-r'); figure(gcf);
plot(X,Y,'-r');
grid
hold off
figure(gcf);

clc;

%....................................
% Begin section to print the results.
%....................................
clc;
% The function is  f(x) = sin(x)
%
% 3-rd degree Taylor polynomial             Order of the approximation
%
%              3
% P (x) = x - x /6                          x^5/120 = O(x^5)
%  3
%
% The error bound is
%
%     |sin(x) - P (x)| <= |x^5/120|  over [-1,1].
%                3

pause % Press any key to continue.

clc;

% (ii)  Show that  |sin(x) - P (x)| <= |x^7/5040|  over [-1,1].
%                             5
%       REMARK. The factor 1.06 was added to separate the curves.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays to plot y = f(x).
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = -1;
b =  1;
F = 'sin(X)-(X-1/6*X.^3+1/120*X.^5)';
G = '1.06*X.^7/5040';
h = (b-a)/100;
X = a:h:b;
Y = eval(F);
Z = eval(G);

clc; figure(2); clg;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = -1;
b =  1;
c = -1/5040;
d =  1/5040;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
title('The error bound  |sin(x) - P5(x)| <= |x^7/5040|  over [-1,1]'); figure(gcf);
% fplot(' 1.06*x^7/5040',[-1 1],'-g'); figure(gcf);
% fplot('-1.06*x^7/5040',[-1 1],'-g'); figure(gcf);
plot(X,Z,'-g',X,-Z,'-g'); figure(gcf);
% fplot('sin(x)-(x-1/6*x^3+1/120*x^5)',[-1 1],'-r'); figure(gcf);
plot(X,Y,'-r');
grid
hold off
figure(gcf);

clc;

%....................................
% Begin section to print the results.
%....................................
clc;
% The function is  f(x) = sin(x)
%
% 5-th degree Taylor polynomial             Order of the approximation
%
%              3      5
% P (x) = x - x /6 + x /120                 x^7/5040 = O(x^7)
%  5
%
% The error bound is
%
%     |sin(x) - P (x)| <= |x^7/5040|  over [-1,1].
%                5

pause % Press any key to continue.

clc;

% (iii) Show that  |sin(x) - P (x)| <= |x^9/362880|  over [-1,1].
%                             7
%       REMARK. The factor 1.08 was added to separate the curves.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays to plot y = f(x).
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

F = 'sin(X)-(X-1/6*X.^3+1/120*X.^5-1/5040*X.^7)';
G = '1.08*X.^9/362880';
h = (b-a)/100;
X = a:h:b;
Y = eval(F);
Z = eval(G);

clc; figure(3); clg;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = -1;
b =  1;
c = -1/362880;
d =  1/362880;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
title('The error bound  |sin(x) - P7(x)| <= |x^9/362880|  over [-1,1]'); figure(gcf);
% fplot(' 1.08*x^9/362880',[-1 1],'-g'); figure(gcf);
% fplot('-1.08*x^9/362880',[-1 1],'-g'); figure(gcf);
plot(X,Z,'-g',X,-Z,'-g'); figure(gcf);
% fplot('sin(x)-(x-1/6*x^3+1/120*x^5-1/5040*x^7)',[-1 1],'-r'); figure(gcf);
plot(X,Y,'-r');
grid
hold off
figure(gcf);

clc;

%....................................
% Begin section to print the results.
%....................................
clc;
% The function is  f(x) = sin(x)
%
% 7-th degree Taylor polynomial             Order of the approximation
%
%              3      5        7
% P (x) = x - x /6 + x /120 - x /5040       x^9/362880 = O(x^9)
%  7
%
% The error bound is
%
%     |sin(x) - P (x)| <= |x^9/362880|  over [-1,1].
%                7

