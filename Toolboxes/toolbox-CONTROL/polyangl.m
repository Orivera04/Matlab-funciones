 function [w] = polyangl(num,den,angle,tol);
% POLYANGL : Calculate roots of a polynomial that are at a given angle
%
%function [w] = polyangl(num,den,angle);
%
% RETURNS the value where the polynomial { num/den }
%         has the phase angle desired ( within 1/2 Degree checked )
angle = rem(rem(angle,360)+360,360)*pi/180; % 0 <= angle < 2*pi
if (nargin < 4); tol = pi/360; else tol = tol*pi/180; end;
%
% Principle : real(Num/(Den*1@Angle) = imag(Num/(Den*1@Angle)
%
dn = den*exp(sqrt(-1)*angle);   % Den*1@Angle
%
w = roots(conv(real(num),imag(dn))-conv(imag(num),real(dn)));
if ( ~ isempty(w) ) , w = w(find(polyval(den,w) ~= 0));  end;  % no divide by zero warnings
if ( ~ isempty(w) ) , w = w(find(polyval(num,w) ~= 0));  end;  % no zero values allowed
val = polyval(num,w)./polyval(den,w);
ii = find(rem(angle-imag(log(val))+2*pi+tol,2*pi)-tol < tol);
w = w(ii);  % answers that meet reasonableness check (within tol)
