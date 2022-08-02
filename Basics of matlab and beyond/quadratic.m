function x = quadratic(a,b,c)

% QUADRATIC Find roots of a quadratic equation.
%
% X = QUADRATIC(A,B,C) returns the two roots of the quadratic equation
%
%                   y = A*x^2 + B*x + C.  
%
% The roots are contained in X = [X1 X2].

% A. Knight, July 1997

delta = 4*a*c;
denom = 2*a;
rootdisc = sqrt(b.^2 - delta); % Square root of the discriminant
x1 = (-b + rootdisc)./denom; 
x2 = (-b - rootdisc)./denom;
x = [x1 x2];
