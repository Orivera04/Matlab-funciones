echo on; clc;
%---------------------------------------------------------------------------
%A1_15  MATLAB script file for investigating Theorem 1.15
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
% Theorem 1.15  (Geometric Series).
% Section 1.2,   Binary Numbers, Page 18
%---------------------------------------------------------------------------

clc; clear all; format long;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Theorem 1.15  (Geometric Series).  If  |r| < 1, then
%
%              2          n             1
%     1 + r + r  + ... + r  + ...  =  ----- .
%                                     1 - r
%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 1.2, page 19.  Find the sum of the infinite series
%
%     1 + 1/4 + 1/16 + 1/64 + 1/256 + ... + 1/4^n + ...

symsum 1/4^n n 0 inf

pause % Press any key to continue.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays to plot y = f(x).
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
X = [];
Y = [];
s = 0;
for n = 0:12,
  X = [X n+1];
  s = s + 1/4^n;
  Y = [Y s];
end

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
a =  0;
b = 10;
c =  1;
d =  1.35;
whitebg('w');
plot([a b],[0 0],'b',[0 0],[c d],'b');
axis([a b c d]);
axis(axis);
hold on;
title('Partial sums for the series  sum 1/4^n.');
plot(X,Y,'or');
xlabel('n');
ylabel('Sn');
grid;
hold off;
figure(gcf);

clc; 

Sn = Y';
format long;
disp(' ');disp(' ');disp('The partial sums are:');disp(' ');disp(Sn);
pause % Press any key to continue.

clc;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Example 1.3, page 21.  Find the sum of the binary number
%                   ____
%     S = 0.1011001100110...
%                           two
% Solution:
%                                         n
%     S = 1/2 + 1/8*(1 + 1/16 + ... + 1/16 + ... )
%                                          n
%             + 1/16*(1 + 1/16 + ... + 1/16 + ... )
%                                          n
%     S = 1/2 + 3/16*(1 + 1/16 + ... + 1/16 + ... )

symsum 1/16^n n 0 inf;
s = ans;
S = symadd('1/2', symmul('3/16', s))


