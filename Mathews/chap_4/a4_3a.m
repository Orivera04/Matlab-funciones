echo on; clc;
%---------------------------------------------------------------------------
%A4_3   MATLAB script file for implementing Algorithm 4.3
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
% Algorithm 4.3 (Lagrange Approximation).
% Section	4.3, Lagrange Approximation, Page 224
%---------------------------------------------------------------------------

clc; clear all; format short;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
%                      ANIMATION
%
% Investigation of the Lagrange coefficient polynomials.
% The root locations and unit values  L   (x ) = 1
%                                      n,j  j
% of the Lagrange coefficient polynomials can be explored.
%
% n+1 are points needed to construct the coefficient polynomials.
% n+1 coefficient polynomials are constructed.
%
% The abscissas are stored in  X.
%
% The points are counted  k=1,2,...,n+1.

pause % Press any key to continue.

clc;
n = 4;  % This example uses the degree n = 4.
a = 0;
h = 1;
b = n;
X = a:h:b;
Y = X;

[W,L] = lagran(X,Y);

pause % Press a key to view the polynomials.

clc;

% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
% Prepare graphics arrays
% ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
x = X;
a = min(X);
b = max(X);
h = (b-a)/150;
x1 = a:h:b;
k  =  1;
n1 = n+1;

clc; figure(1); clf;

%~~~~~~~~~~~~~~~~~~~~~~~
% Begin graphics section
%~~~~~~~~~~~~~~~~~~~~~~~
whitebg('w');
a = min(X);
b = max(X);
while k<=n
  Z = zeros(1,n1);
  Z(k) = 1;
  y1 = polyval(L(k,:),x1);
  c = min(y1);
  d = max(y1);
  clc; figure(k); clf;
  whitebg('w');
  plot([a b],[0 0],'b',[0 0],[c d],'b');
  axis([a b c d]);
  axis(axis);
  hold on;
  plot(X,Z,'or',x1,y1,'-g');
  xlabel('x');
  ylabel('y');
  Mx1 = 'The Lagrange coefficient polynomial  L';
  Mx2 =[Mx1,num2str(n),',',num2str(k),' (x)'];
  title(Mx2);
  grid;
  hold off;
  figure(gcf);
  Mx3 = 'The abscissas are:';
  Mx4 = 'The ordinates are:';
  clc,disp(Mx2),disp(L(k,:)),disp(''),disp(Mx3),disp(X),disp(Mx4),disp(Z)
  k = k+1;
end

clc;
%............................................
% Begin section to print the results.
% Diary commands are included which write all
% the results to the Matlab textfile   output
%............................................
Mx1 = 'The abscissas are an n+1 dimensional vector X.';
Mx2 = 'The vector evaluation  Ln,k(X)  of X with each a Lagrange';
Mx3 = 'coefficient polynomial produces a standard base vector.';
clc,disp(Mx1),disp(X),disp(Mx2),disp(Mx3),...
for k = 1:n+1,disp(round(polyval(L(k,:),X))), end
