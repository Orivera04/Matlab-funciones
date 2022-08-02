function h=mmhypot(x,y)
%MMHYPOT Hypotenuse. (MM)
% MMHYPOT(X,Y) returns an array the same size as X and Y
% containing SQRT(X.^2 + Y.^2).
% MMHYPOT(C) where C is a complex-valued array, returns an
% array the same size as C containing |C|.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 3/27/01
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==1 & ~isreal(x)
   h=abs(x);
elseif nargin==2 & isreal(x) & isreal(y)
   h=abs(complex(x,y)); % faster and more accurate than sqrt(x.^2+y.^2)
else
   error('Improper Input Data Provided.')
end