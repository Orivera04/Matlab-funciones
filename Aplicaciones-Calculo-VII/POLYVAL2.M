function Z = polyval2(C,x,y, method)
% polyval2.m  evaluates a 2D polynomial fitting from intfit2.m
%
% USAGE:  Z = polyval2(C,X,Y,'method') 
% ======  returns matrix Z containing evaluations of a least-squares 
%         polynomial in x and y, 
% where coefficients "C" has been based on 'method' = 
%                    'linear' - bilinear linear squares fitting  OR
%                     'cubic'  - bicubic linear squares fitting
% Again non-equally spaced X and Y are permitted but note that
%       you may not plot the polynomial at nonuniformly meshes.
%
% For example, generate a coarse 2D sine curve and a least squares fitting
% ver finer abscissa:
%                  x = 0:10; y = 1:9;  [x y] = meshgrid(x,y) ; 
%                  z = sin(x.*y);
%                 xi = 0:.25:10; yi=2:.5:8 ; [xi yi]=meshgrid(xi,yi);
%                 C  = polyfit2(x,y,z, 'cubic');
%                 zi = polyval2(C, xi,yi, 'cubic');

if nargin<=2
	disp('Insufficient number of options are supplied');
	disp('                       Error in polyval2')
	help polyval2
	return
end

% Check the arguments.
if nargin<4,
  method = 'linear';
end

if ~isstr(method),   %%% Any string
  error('METHOD must be one of the strings: ''linear'',''cubic''.');
end

if size(x)~=size(y),
  error('X must have the same size as Y.');
end

[m n] = size(x); mn = m*n ;
  x = reshape(x,mn,1) ;
  y = reshape(y,mn,1) ;

if method(1)=='l', % Linear interpolation
  Z = C(1) + C(2)*x + C(3)*y + C(4)*x.*y ;

elseif method(1)=='c', % Cubic interpolation
  Z = C(1) + C(2)*x + C(3)*y + C(4)*x.*y + C(5)*x.^2 + C(6)*y.^2 ;
  Z = Z    + C(7)*(x.^2).*y + C(8)*x.*y.^2 + C(9)*x.^3 + C(10)*y.^3 ;
else
  error([method,' is an invalid method.']);
end

% Recover a matrix form
  x = reshape(x,m,n) ;
  y = reshape(y,m,n) ;
  Z = reshape(Z,m,n) ;
