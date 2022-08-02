echo on; clc;
%---------------------------------------------------------------------------
%A6_E   MATLAB script file for implementing Algorithm 6.e
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
% Algorithm 6.e (Error Analysis for Numerical Differentiation).
% Section	6.1, Approximating the Derivative, Page 326
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% This program investigates the error E(f,h) when
% computing numerical approximation for f'(x).  Two central
% Two central difference formulas are explored:
%
%            f(x+h) - f(x-h)
%  f'(x)  =  ---------------  +  E(f,h)
%                  2h
%
%            - f(x+2h) + 8f(x+h) - 8f(x-h) + f(x-2h)
%  f'(x)  =  ---------------------------------------  +  E(f,h)
%                              12h
%
%
% The function f(x) is stored in the M-file  f.m
% function z = f(x)
% z = cos(x);

pause % Press any key to continue.

clc;
%.......................................................................
% Begin a section which enters the function(s) necessary for the example
% into M-file(s) by executing the diary command in this script file.
% The preferred programming method is not to use these steps.
% One should enter the function(s) into the M-file(s) with an editor.
delete output
delete f.m
diary  f.m; disp('function z = f(x)');...
            disp('z = cos(x);');...
diary off;
f(0); % Remark. f.m is used for Algorithm 6.e
pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - -
%
%                f(x+h) - f(x-h)
% For  f'(x)  ~  ---------------
%                      2h
%
% The error bound is known to have the general form:
%
%         |E(f,h)| <= eps/h + m h^2/6
%
% and the optimum step size is  
%
%         h = (3 eps/m)^(1/3)
%
% where  eps  is machine epsilon (round off).
%
pause % Press any key to continue. 

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example, page 321-322  Investigate the error for numerical approximation
% f'(0.8)  for the function  f(x) = cos(x).  Look for the optimal step size.
%
% Enter the differentiation point in  x 
%
% Enter a bound for   |f'''(c)|   in  m

x = 0.8;

m = 1;

hopt = (3*eps/m)^(1/3);

emin = eps/hopt + m*hopt^2/6;

pause % Press any key to graph the error bound.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = hopt/10000;
b = 3.44*hopt; %b = 0.00003;
h  = (b-a)/150;
H = a:h:b;
B = eps./H + m*H.^2/6;
E = abs(- sin(x) - (f(x+H) - f(x-H))./(2*H));

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = hopt/10000;
b = 3.44*hopt; %b = 0.00003;
c = 0;
d = 5.25*emin; %d = 0.0000000002;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(H,E,'-r',H,B,'-g');
xlabel('h');
ylabel('e');
title('|E(f,h)| <= eps/h + m h^2/6');
grid;
hold off;
figure(gcf); pause	% Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'Graph of the error bound  B = eps/h + m h^2/6,';
Mx2 = 'and error in the approx.  E = |E(f,h)|.';
Mx3 = 'The two curves verify the relationship:';
Mx4 = '     |E(f,h)| <= eps/h + m h^2/6';
Mx5 = 'The optimum step size from the theory is:';
Mx6 = '     hopt = (3 eps/m)^(1/3) = ';
Mx7 = [Mx6,num2str(hopt)];
Mx8 = 'The minimum error from the theory is:';
Mx9 = '     emin = eps/hopt + m hopt^2/6 = ';
Mx10 = [Mx9,num2str(emin)];
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),...
disp(''),disp(Mx3),disp(''),disp(Mx4),...
disp(''),disp(Mx5),disp(''),disp(Mx7),...
disp(''),disp(Mx8),disp(''),disp(Mx10),diary off,echo on
pause % Press any key to continue.

clear; clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
%                - f(x+2h) + 8f(x+h) - 8f(x-h) + f(x-2h)
% for  f'(x)  ~  ---------------------------------------
%                                  12h
%
% The error bound is known to have the general form:
%
%         |E(f,h)| <= 3/2 eps/h + m h^4/30   and the
%
% Optimum step size  
%
%         h = (45/4 eps/m)^(1/5)
%
% where  eps  is machine epsilon (round off).

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example, page 323-324  Investigate the error for numerical approximation
% f'(0.8)  for the function  f(x) = cos(x).  Look for the optimal step size.
%
% Enter the differentiation point in  x 
%
% Enter a bound for  |f'''''(c)|  in  m

x = 0.8;

m = 1;

hopt = ((45/4)*eps/m)^(1/5);

emin = (3/2)*eps/hopt + m*hopt^4/30;

pause	% Press any key to graph the error bound.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
a = hopt/10000;
b = 2.51*hopt; %b = 0.003;
h  = (b-a)/150;
H = a:h:b;
B = (3/2)*eps./H + m*H.^4/30;
E = abs(- sin(x)-(-f(x+2*H)+8*f(x+H)- 8*f(x-H)+ f(x-2*H))./(12*H));

clc; figure(2); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a = hopt/10000;
b = 2.51*hopt; %b = 0.003;
c = 0;
d = 5.78*emin; %d = 0.000000000002;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
plot(H,E,'-r',H,B,'-g');
xlabel('h');
ylabel('e');
title('|E(f,h)| <= 3/2 eps/h + m h^4/30');
grid;
hold off;
figure(gcf); pause % Press any key to continue.

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'Graph of the error bound  B = 3/2 eps/h + m h^4/30,';
Mx2 = 'and error in the approx.  E = |E(f,h)|.';
Mx3 = 'The two curves verify the relationship:';
Mx4 = '     |E(f,h)| <= 3/2 eps/h + m h^4/30';
Mx5 = 'The optimum step size from the theory is:';
Mx6 = '     hopt = (45/4 eps/m)^(1/5) = ';
Mx7 = [Mx6,num2str(hopt)];
Mx8 = 'The minimum error from the theory is:';
Mx9 = '     emin = 3/2 eps/hopt + m hopt^4/30 = ';
Mx10 = [Mx9,num2str(emin)];
clc,echo off,diary output,...
disp(''),disp(Mx1),disp(''),disp(Mx2),...
disp(''),disp(Mx3),disp(''),disp(Mx4),...
disp(''),disp(Mx5),disp(''),disp(Mx7),...
disp(''),disp(Mx8),disp(''),disp(Mx10),diary off,echo on
