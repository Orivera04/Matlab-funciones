echo on; clc;
%---------------------------------------------------------------------------
%A1_5   MATLAB script file for investigating Theorem 1.5
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
% Theorem 1.5  (Rolle's Theorem).
% Section 1.1,  Review of Calculus, Page 5
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Theorem 1.5  (Rolle's Theorem).  Assume that  f  is continuous
%
% on the interval [a,b] and that  f'(x) exists for all a < x < b.
%
% If  f(a) = f(b) = 0, then there exists a value  c,  with
%
% a < c < b, such that  f'(c) = 0.
%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example for page 5.  The function  f(x) = sin(x) - 1/2
%
% has two zeros in the interval [0,3].  
%
% According to Rolle's theorem, there exists a 
%
% value  c  with 0 < c < 3 such that  f'(c) = 0.

% Enter the function  f  and find its zeros.
f  = 'sin(x) - 0.5';
solve('sin(x) - 0.5 = 0','x')
r1 = asin(1/2)
r2 = r1 + 2*(pi/2-r1)

% Find the function  f'  and its zero.
df = diff(f,'x')
solve(df,'x')
c1 = pi/2;
x = c1;
y1 = eval(f);

pause % Press any key to continue.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays to plot y = f(x).
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a =  0;
b =  3;
F = 'sin(X) - 0.5';
h = (b-a)/100;
X = a:h:b;
Y = eval(F);

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a =  0;
b =  3;
c = -0.6;
d =  0.6;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
title('Rolle`s theorem solves  f`(c) = 0.'); figure(gcf);
% fplot(f,[a b],'-g'); figure(gcf);
plot(X,Y,'-g'); figure(gcf);
plot([r1 r2],[0 0],'ob');
plot(c1,y1,'or');
plot([c1-0.5 c1+0.5],[y1 y1],'-r'); figure(gcf);
plot(c1,0,'or');
plot([c1 c1],[0 y1],'--r');
xlabel('x');
ylabel('y');
grid;
hold off;
clc;
figure(gcf);
 
clc;

%....................................
% Begin section to print the results.
%....................................
clc;disp(' ');disp(' ');disp(['f(x) = ' f]); disp(' ');...
disp('The values where f(x) = 0 are:');...
disp(' ');disp([r1 r2]');disp(' ');...
disp('The value c where f`(c) = 0 is:');...
disp(' ');disp(c1);

