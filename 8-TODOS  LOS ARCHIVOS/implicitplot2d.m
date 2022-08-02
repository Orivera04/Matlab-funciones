function out=implicitplot2d(varargin)
%IMPLICITPLOT2D 2-D implicit plot
% IMPLICITPLOT2D(eqstring, val, xvar, yvar, xmin, xmax, ymin, ymax)
% plots a an implicit equation
% eqstring=val, where eqstring is a symbolic function of (symbolic)
% variables xvar and yvar in the indicated range, and val is a number.
% If xvar and yvar are not specified, it is assumed they are 'x' and 'y',
% respectively. The optional parameter plotpoints (added at the end)
% gives the number of steps in each direction between plotting points.
%
% Example: implicitplot2d('x^2+y^2', 5, -3, 3, -3, 3)
% plots the circle 'x^2+y^2=5' with 'x' going from -3 to 3 and 
% with 'y' going from -3 to 3.
%
% Another example: implicitplot2d('t^2-u^3+u', 0,'u', 't', -2, 2, -3, 3)
% plots the elliptic curve 't^2=u^3-u' with 'u' going from -2 to 2 and 
% with 't' going from -3 to 3.
% implicitplot2d('t^2-u^3+u', 0,'u', 't', -2, 2, -3, 3, 50) does the same
% thing with higher accuracy.
% written by Jonathan Rosenberg, 7/30/99


if nargin<6, error('not enough input arguments -- need at least expression string, value, xmin, xmax, ymin, ymax'); end

if nargin>9, error('too many input arguments'); end

eqstring=varargin{1}; val=varargin{2};

if  nargin>7, xvar=varargin{3}; yvar=varargin{4}; end
if  nargin<8, xvar='x'; yvar='y'; end
if  nargin>7, xmin=varargin{5}; xmax=varargin{6}; 
        ymin=varargin{7}; ymax=varargin{8}; end
if  nargin<8, xmin=varargin{3}; xmax=varargin{4}; 
        ymin=varargin{5}; ymax=varargin{6}; end
% Default value of plotpoints is 30.
plotpoints=30;
if  nargin==9, plotpoints = varargin{9}; end
if  nargin==7, plotpoints = varargin{7}; end


F=vectorize(inline(eqstring,xvar,yvar));

[X Y]= meshgrid(xmin:(xmax-xmin)/plotpoints:xmax, ymin:(ymax-ymin)/plotpoints:ymax);
Z = F(X, Y);
contour(X, Y, Z, [val val])
xlabel(xvar)
ylabel(yvar)
title([eqstring,' = ',num2str(val)], 'Interpreter','none')
