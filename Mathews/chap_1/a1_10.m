echo on; clc;
%---------------------------------------------------------------------------
%A1_10   MATLAB script file for investigating Theorem 1.10
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
% Theorem 1.10  (Second Fundamental Theorem).
% Section 1.1,   Review of Calculus, Page 8
%---------------------------------------------------------------------------

clc; clear all; format long;

% Theorem 1.10  (Second Fundamental Theorem).  If  f  is continuous
%
% over the interval [a,b], then
%
%         x
%     d   /
%     --  | f(t) dt  =  f(x).
%     dx  /
%         a         
%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%                                   4 3x
% Example for page 7.  Let  f(x) = x e  sin(2x).  
%
%                  x
%              d   /
% Show that    --  | f(t) dt  =  f(x).
%              dx  /
%                  0
f = 't^4*exp(3*t)*sin(2*t)'
g = int(f,'t',0,'x')
diff(g,'x')

clc;

%....................................
% Begin section to print the results.
%....................................
clc;disp(' ');disp(' ');disp('The function f(t) is:');...
disp(' ');disp(['f(t) = ' f]);...
disp(' ');disp('The integral is:');...
disp(' ');disp('x');...
disp(' ');disp('/');...
disp(' ');disp('| f(t)dt = g(x) = ');...
disp(' ');disp('/');...
disp(' ');disp('0');disp(g);...
disp(' ');disp('The derivative of g(x) is:');...
disp(' ');disp(['g`(x) = ' diff(g,'x')]);disp(' ');

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%                                                 2
%                                               -x /2
% Example for page 7.  Let  f(x) = 1/sqrt(2*pi)e     .  
%
%              d   x
% Show that    --  Ÿ f(t) dt  =  f(x).
%              dx  0

f = 'exp(-t^2/2)/sqrt(2*pi)'
g = int(f,'t',0,'x')
diff(g,'x')

pause % Press any key to continue.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays to plot y = f(x).
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = -3;
b =  3;
F = 'exp(-1/2*X.^2)/sqrt(2*pi)'
h = (b-a)/100;
X = a:h:b;
Y = eval(F);

clc; figure(1); clf;
subplot(2,1,1);

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = -3;
b =  3;
c =  0;
d =  0.5;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
title('Graph of the function  y = f(x).');
% fplot(f,[a b],'-g');
plot(X,Y,'-g');
xlabel('x');
ylabel('y');
grid;
hold off;
figure(gcf);

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays to plot y = int f(x)dx.
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = -3;
b =  3;
Fint = '1/2*erf(1/2*2^(1/2)*X) + 1/2' 
h = (b-a)/100;
X = a:h:b;
Z = eval(Fint);

clc;
subplot(2,1,2);

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = -3;
b =  3;
c = -0.05;
d =  1.05;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
title('Graph of the integral  y = int f(x)dx.');
% fplot(g,[a b],'-g');
plot(X,Z,'-g');
xlabel('x');
ylabel('y');
grid;
hold off;
figure(gcf);

clc;

%....................................
% Begin section to print the results.
%....................................
clc;disp(' ');disp(' ');disp('The function f(t) is:');...
disp(' ');disp(['f(t) = ' f]);...
disp(' ');disp('The integral is:');...
disp(' ');disp(' x');...
disp(' ');disp(' Ÿ f(t)dt = g(x) = ');...
disp(' ');disp('-oo');disp([g ' + 1/2']);...
disp(' ');disp('The derivative of g(x) is:');...
disp(' ');disp(['g`(x) = ' diff(g,'x')]);disp(' ');
