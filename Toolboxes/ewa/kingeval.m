% kingeval.m - evaluate King's 3-term sinusoidal current approximation
%
% Usage: I = kingeval(L,A,z)
%
% L = antenna length in wavelengths
% A = coefficient vector for sinusoidal terms A = [A1] or [A1,A2] or [A1,A2,A3]
% z = points at which to evaluate the current I(z)
%
% I = current values of the 3-term expression at z 
%
% notes: if A=[A1], use the standard dipole current I(z) = A1 * sin(k(h-abs(z)))
%
%        A is obtaind from KING or KINGFIT, e.g., A = kingfit(L,In,zn,terms)

% S. J. Orfanidis - 1999 - www.ece.rutgers.edu/~orfanidi/ewa

function I = kingeval(L,A,z)

if nargin==0, help kingeval; return; end

col = size(z,1);    

A = A(:);
z = z(:);

h = L/2;
k = 2*pi;

terms = length(A);

if terms==2,
    A = [A; 0];
end

if rem(2*L,2)==1,                   % L is odd multiple of lambda/2
    S = [sin(k*abs(z))-sin(k*h), cos(k*z)-cos(k*h), cos(k*z/2)-cos(k*h/2)];
else
    S = [sin(k*(h-abs(z))), cos(k*z)-cos(k*h), cos(k*z/2)-cos(k*h/2)];
end

if terms==1,
    I = A(1) * sin(k*(h-abs(z)));
else
    I = S * A;
end

if col==1, I = I.'; end




