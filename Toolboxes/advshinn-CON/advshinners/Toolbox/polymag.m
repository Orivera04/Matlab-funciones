 function [w] = polymag(num,den,mag);
% POLYMAG : Calculate roots of a polynomial that are at a given magnitude
%
%function [w] = polymag(num,den,mag);
%
% Evaluates a polynomial (num/den) 
% RETURNS the coeficient(s) that will make the polynomial (num/den)
%         evaluate to the specified magnitude (regardless of phase).
%
% Some typical applications are:
%   a) Phase margin evaluation
%   b) 3 Db point
mag = abs(mag); % make sure that mag is |mag|
%
% Principle : (Num/Den)*conj(Num/Den) = (Mag@Angle)*conj(Mag@Angle)
%
w = roots(poly_add(conv(num,conj(num)),-conv(den,conj(den))*mag^2));
% check that the returned values are within 1% of the desired mag
w = w(find(polyval(den,w) ~= 0));   % no divide by zero checks
val = polyval(num,w)./polyval(den,w);
ii=find(abs(abs(val)-abs(mag)) < 0.01*abs(mag));
w = w(ii); % eliminate all false answers
