 function [k,s] = rootangl(num,den,angle,tol)
% ROOTANGL : Calculate the roots on a given angle in the root locus
%
%function [k,s] = rootangl(num,den,angle)
%
angle = rem(rem(angle,360)+360,360)*pi/180; % 0 <= angle < 2*pi
if (nargin < 4), tol = pi/360; else tol = tol*pi/180; end;
%
% Rotate axis making desired angle
[n,d] = polysbst(num,den,[exp(sqrt(-1)*angle) 0],1);
s = polyangl(n,d,180)*exp(sqrt(-1)*angle);
% Screen for tolerance
s = s(find(abs(rem(angle-imag(log(s))+2*pi+tol,2*pi)-tol) < tol));
% Evaluate k
k = -polyval(den,s)./polyval(num,s);
% Screen for k valid
ii = find(k >= 0); s = s(ii); k = abs(k(ii)); % positive real k only
