% EX4_18.M Symbolic solution of second order differential equation
%   in terms of eigenvalues and eigenvectors
% (This requires the Symbolic Math Toolbox)
%
A=sym('[-b/m1,b/m1;b/m2,-b/m1]')
[V,E]=eig(sym(A))
fprintf('Press a key to see m1=m2 solution \n')
pause
%
% Let m1=m2=m and redo with symmetric matrix
%
Asymm=sym('[-b/m,b/m;b/m,-b/m]')
[Vsymm,Esymm]=eig(sym(Asymm))
%
% The two eigenvalues here (0,-2*b/m) determine the time
%   response of the motion. The eigenvectors determine
%   the relative motion. The analysis is treated further
%   in Chapter 5.
%
%  You can simplify the matrices since b multiplies every 
%    element in the general case. Also, b/m is common for the
%    symmetrical case. 
%
% Version 5 Replace eigsys(A) with eig(sym(A))