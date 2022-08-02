function z=Hfun(x,y)
% Integrand function defined over a rectangular
% region.  The support of this function is the
% subregion 0 < x < 1,  x^2 < y < sqrt(x).
global h

% In the commands below '(x.^2<y & y<sqrt(x))' defines
% a matrix of ones and zeros.  A one occurs when the
% logical relation between the entries of matrices x 
% and y is true.

z=(x.^2<y & y<sqrt(x)).*h(x,y);