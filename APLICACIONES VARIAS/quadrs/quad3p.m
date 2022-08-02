function q = quad3p(x,y)

% QUAD3P  Integral of quadratic function given by 3 points.
%	Q = QUAD3P(X,Y) Returns estimate of integral between
%	points X1 and X3 based on the quadratic interpolation
%	of function Y given by values Y = [Y1 Y2 Y3] at the
%	points X = [X1 X2 X3].
%	X, Y can be 3 by 1 vectors or 3 by N matrices, in
%	which case the integration is performed for each
%	column of X, Y.

%  Kirill K. Pankratov,  kirill@plume.mit.edu
%  01/26/95

 % Handle input ........................
if nargin < 1, help quad3p, return, end
if nargin == 1, y = x; x = [1 2 3]'; end
if size(x,1)==1, x = x'; end
if size(x,2)==1, x = x(:,ones(1,size(y,2))); end

 % Calculate intervals and auxillary parameters
h1 = x(2,:)-x(1,:);
h2 = x(3,:)-x(2,:);
h = h1+h2;
d = (h2-h1)/2;
s3 = (h1.^3+h2.^3)/3;

 % Calculate coefficients for integral
x(1,:) = (-d.*h2+s3./h)./h1;
x(2,:) = h+(2*d.*d.*h-s3)./(h1.*h2);
x(3,:) = ( d.*h1+s3./h)./h2;

 % Integral itself ..................
q = sum(x.*y);

