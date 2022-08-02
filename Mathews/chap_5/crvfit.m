function Clist = crvfit(x,y,ct)
%---------------------------------------------------------------------------
%CRVFIT   Construct the least squares curve fit.
% Sample call
%   Clist = crvfit(x,y,ct)
% Inputs
%   x       vector of abscissas
%   y       vector of ordinates
%   ct      curve type
% Return
%   Clist   coefficient list for the curve
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

if length(ct)==0, ct=2; end
L = 0;
if ct==10,
  clc;
  disp('             Y = '),disp(y),...
  disp('          y(x) = L/(1 + C exp(Ax))'),...
  disp('     lim  y(x) = L'),...
  disp('    x-->oo'),...
  L = input('Enter the constant L = '); 
end
if length(L)==0, L=0; end
if L <= max(y), 
  L=max(y)+0.01*abs(max(y)); 
end
if ct==1, X=x.^(-1); Y=y; end
if ct==2, X=x.*y; Y=y; end
if ct==3, X=x; Y=y.^(-1); end
if ct==4, X=x.^(-1); Y=y.^(-1); end
if ct==5, X=log(x); Y=y; end
if ct==6, X=x; Y=log(y); end
if ct==7, X=log(x); Y=log(y); end
if ct==8, X=x; Y=sqrt(y).^(-1); end
if ct==9, X=x; Y=log(y./x); end
if ct==10,X=x; Y=log(L.*y.^(-1)-1); end
AB = polyfit(X,Y,1);
A = AB(1);
B = AB(2);
C = 0; D = 0;
if ct==2, C=-1/A; D=-B/A; end
if ct==6, C=exp(B); end
if ct==7, C=exp(B); end
if ct==9, C=exp(B); D=-A; end
if ct==10,C=exp(B); end
Clist = [A B C D L];
