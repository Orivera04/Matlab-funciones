function C = polyfit2(x,y,z, method)  
% polyfit2 is for 2-D data fitting using least squares
%
% USAGE:   C = polyfit2(X,Y,Z, 'method') 
% ======where an output vector C contains the bi-linear or bi-cubic
%       coefficients of a least-squares polynomial in x and y, and
%       input matrices X, Y, Z are for a 2D function z=f(x,y).
%
% Here 'method' can be
%         'linear' - bilinear least squares fitting
%         'cubic'  -  bicubic least squares fitting
%       Non-equally spaced (or even non-monotonic) X and Y are permitted.
%
%       For example, generate a coarse 2D curve and a least squares fitting
%       over finer mesh (meshdom with Matlab 3.5 BUT meshgrid with Matlab 4)
%                  x = 0:10; y = 1:9;  [x y] = meshdom(x,y) ; 
%                            z = sin(x.*y);
%                  xi = 0:.25:10; yi=2:.5:8 ; [xi yi]=meshdom(xi,yi);
%                  C  = polyfit2(x,y,z, 'cubic');
%                  zi = polyval2(C, xi,yi, 'cubic');
if nargin<=2, format compact
   disp('Insufficient number of options are supplied');
   disp('                       Error in polyfit2');help polyfit2
   return
end

% Check the arguments.
if nargin<4,
  method = 'linear';
end

if ~isstr(method),   %%% Any string
  error('METHOD must be one of the strings: ''linear'',''cubic''.');
end

if size(x)~=size(z),
  error('X must have the same dimension as Z.');                      
end
if size(y)~=size(z),
  error('Y must have the same dimension as Z.');                      
end

[m,n] = size(z); mn = m*n  ;  

  x = reshape(x,mn,1) ;
  y = reshape(y,mn,1) ;
  z = reshape(z,mn,1) ;

if method(1)=='l', % Linear least squares 
  A = [ ones(size(x))  x  y  x.*y ] ;
  C  = A \ z ;

elseif method(1)=='c', % Cubic least squares 
  A = [ ones(size(x))  x  y  x.*y  x.^2  y.^2  (x.^2).*y  x.*(y.^2)  x.^3  y.^3];
  C  = A \ z ;

else
  error([method,' is an invalid method.']);
end
 
%% Finally  Output as a row vector
C  = C' ;
  x = reshape(x,m,n) ;
  y = reshape(y,m,n) ;
  z = reshape(z,m,n) ;

