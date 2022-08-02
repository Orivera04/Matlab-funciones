echo on; clc;
%---------------------------------------------------------------------------
%A1_8   MATLAB script file for investigating Theorem 1.8
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
% Theorem 1.8  (Generalized Rolle's Theorem).
% Section 1.1,  Review of Calculus, Page 6
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Theorem 1.8  (Generalized Rolle's Theorem).  Assume that  f  is
%
% continuous on the interval [a,b] and that the derivatives
%                      (n)
% f'(x), f''(x), ... ,f   (x) exist on the interval (a,b)
%
% and that  x , x , ... , x  all lie in [a,b].
%            0   1         n
%
% If f(x ) = 0  for  j=0,1,...,n  then there exists a
%       j                                 (n)
% value  c,  with  a < c < b  such that  f  (c) = 0.
%
%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example for page 6.  The function  f(x) = x^3-7*x^2+14*x-8
%
% has three zeros in the interval [0,5].  
%
% According to the generalized Rolle's theorem, there exists a 
%
% value  c  with 0 < c < 5 such that  f''(c) = 0.

% Enter the function  f  and find its zeros.
f  = 'x^3-7*x^2+14*x-8';
solve(f)
r1 = 1; r2 = 2; r3 = 4;

% Enter the function  f'  and find its zeros.
diff(f,'x')
df = '3*x^2-14*x+14';
solve(df)
c1 = 7/3+1/3*7^(1/2); c2 = 7/3-1/3*7^(1/2);

% Enter the function  f''  and find its zero(s).
diff(f,'x',2)
ddf = '6*x-14';
solve(ddf)
c0 = 7/3;

pause % Press any key to continue.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays to plot y = f(x).
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a =  0;
b =  5;
F = 'X.^3-7*X.^2+14*X-8';
h = (b-a)/100;
X = a:h:b;
Y = eval(F);

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a =  0;
b =  5;
c = -3;
d =  3;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
title('The function y = f(x) has 3 zeros in [0,5].'); figure(gcf);
% fplot(f,[a b],'-g');
plot(X,Y,'-g');
plot([r1 r2 r3],[0 0 0],'or');
xlabel('x');
ylabel('y');
grid;
hold off;
figure(gcf);

clc;

%....................................
% Begin section to print the results.
%....................................
clc;disp(' ');disp(' ');disp(' ');disp(['f(x) = ' f]);disp(' ');...
disp(' ');disp('The zeros of f(x) are:');disp(' ');disp([r1 r2 r3]');

pause % Press any key to continue.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays to plot y = f'(x).
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a =  0;
b =  5;
dF = '3*X.^2-14*X+14';
 h = (b-a)/100;
 X = a:h:b;
dY = eval(dF);

clc; figure(2); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a =  0;
b =  5;
c = -3;
d =  3;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
title('The function y = f`(x) has 2 zeros in [0,5].'); figure(gcf);
% fplot(df,[a b],'-g');
plot(X,dY,'-g');
plot([c1 c2],[0 0],'or');
xlabel('x');
ylabel('y');
title('The function y = f`(x) has 2 zeros in [0,5].'); figure(gcf);
grid;
hold off;
figure(gcf);

clc;

%....................................
% Begin section to print the results.
%....................................
clc;disp(' ');disp(' ');disp(['f`(x) = ' df]);disp(' ');...
disp(' ');disp('The zeros of f`(x) are:');disp(' ');disp([c1 c2]');

pause % Press any key to continue.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays to plot y = f''(x).
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a =  0;
b =  5;
ddF = '6*X-14';
  h = (b-a)/100;
  X = a:h:b;
ddY = eval(ddF);

clc; figure(3); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a =  0;
b =  5;
c = -3;
d =  3;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
title('The function y = f``(x) has 1 zero in [0,5].'); figure(gcf);
% fplot(ddf,[a b],'-g');
plot(X,ddY,'-g');
plot([c0],[0],'or');
xlabel('x');
ylabel('y');
grid;
hold off;
figure(gcf);

clc;

%....................................
% Begin section to print the results.
%....................................
clc;disp(' ');disp(' ');disp(['f``(x) = ' ddf]); disp(' ');...
disp(' ');disp('The zero of f``(x) is:');disp(' ');disp(c0);
