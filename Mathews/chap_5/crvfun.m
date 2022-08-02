function z = crvfun(Clist,ct,x)
%---------------------------------------------------------------------------
%CRVFUN   Evaluates the function created with crvfit.
% Sample call
%   z = crvfun(Clist,ct,x)
% Inputs
%   Clist   coefficient list for the curve
%   ct      curve type
%   x       independent variable input value(s)
% Return
%   z       function value(s)
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
% Algorithm 5.3 (Non-linear Curve Fitting).
% Section	5.2, Curve Fitting, Page 280
%---------------------------------------------------------------------------

A = Clist(1);
B = Clist(2);
C = Clist(3);
D = Clist(4);
L = Clist(5);
if ct==1, z = A./x + B; end
if ct==2, z = D./(x + C); end
if ct==3, z = (A.*x + B).^(-1); end
if ct==4, z = x./(A + B.*x); end
if ct==5, z = A*log(x) + B; end
if ct==6, z = C*exp(A.*x); end
if ct==7, z = C.*x.^A; end
if ct==8, z = (A.*x + B).^(-2); end
if ct==9, z = C.*x.*exp(-D.*x); end
if ct==10,z = L./(1 + C.*exp(A.*x)); end
