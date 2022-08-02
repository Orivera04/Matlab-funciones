function out=implicitplot3d(varargin)
%IMPLICITPLOT3D 3-D implicit plot
% IMPLICITPLOT3D(eq, val, xvar, yvar, zvar, xmin, xmax, 
% ymin, ymax, zmin, zmax) plots an implicit equation
% eq=val, where eq is either symbolic expression of (symbolic)
% variables xvar, yvar, and zvar in the indicated ranges, or
% a string representing such an expression, and val is a number.
% If xvar, yvar, and zvar are not specified, it is assumed they are 
% x, y, z in the symbolic case, or 'x', 'y',and 'z' in the
% string form of the command, respectively.
% The optional parameter plotpoints (added at the end)
% gives the number of steps in each direction between plotting points.
%
% Example: implicitplot3d('x^2+y^2+z^2', 5, -3, 3, -3, 3, -3, 3)
% plots the sphere 'x^2+y^2+z^2=5' with 'x', 'y', and 'z' 
% going from -3 to 3.
% implicitplot3d('x^2+y^2+z^2', 5, -3, 3, -3, 3, -3, 3, 30)
% does the same with higher accuracy.
% written by Jonathan Rosenberg, 7/30/99
% rewritten for MATLAB 7, 8/22/05

if nargin<8 
    error('not enough input arguments -- need at least expression string, value, xmin, xmax, ymin, ymax, zmin, zmax'); 
end

if nargin==10, error('impossible number of input arguments'); end

if nargin>12, error('too many input arguments'); end

% Default value of plotpoints is 10.
plotpoints=10;

eq=varargin{1}; val=varargin{2};
stringflag=ischar(eq); % This is 'true' in the string case,
% 'false' in the symbolic case.


% Next, handle subcase where variable names are missing.
if nargin<10
  if stringflag  % First we deal with the string case.
      xvar='x'; yvar='y'; zvar='z'; 
  else % Now deal with the case where eq is symbolic.
      syms x y z; xvar=x; yvar=y; zvar=z;
  end
  xmin=varargin{3}; xmax=varargin{4}; 
  ymin=varargin{5}; ymax=varargin{6}; 
  zmin=varargin{7}; zmax=varargin{8}; 
  if nargin==9, plotpoints=varargin{9}; end
end
% Next, handle subcase where variable names are included.
if nargin>10
  xvar=varargin{3}; yvar=varargin{4}; zvar=varargin{5}; 
  xmin=varargin{6}; xmax=varargin{7}; 
  ymin=varargin{8}; ymax=varargin{9}; 
  zmin=varargin{10}; zmax=varargin{11}; 
  if nargin==12, plotpoints=varargin{12}; end
end

    

if stringflag
    F = vectorize(inline(eq,xvar,yvar,zvar));
else
    F = inline(vectorize(eq),char(xvar),char(yvar),char(zvar));
end
[X Y]= meshgrid(xmin:(xmax-xmin)/plotpoints:xmax, ymin:(ymax-ymin)/plotpoints:ymax);

%% Go through zvalues one at a time. For each one, plot corresponding
%% contourplot in x and y, with that z-value.  We could use "contour" 
%% except that it makes a "shadow", so we copy some of 
%% the code of "contour".

for z=zmin:(zmax-zmin)/plotpoints:zmax
    lims = [min(X(:)),max(X(:)), min(Y(:)),max(Y(:))];
    c = contours(X,Y,F(X,Y,z), [val val]);
    limit = size(c,2);
    i = 1;
    h = [];
	while(i < limit)
	  npoints = c(2,i);
	  nexti = i+npoints+1;
	  xdata = c(1,i+1:i+npoints);
	  ydata = c(2,i+1:i+npoints);
	  zdata = z + 0*xdata;  % Make zdata the same size as xdata
	  line('XData',xdata,'YData',ydata,'ZData',zdata); hold on;
	  i = nexti;
    end
end
view(3)
xlabel(char(xvar))
ylabel(char(yvar))
zlabel(char(zvar))
title([char(eq),' = ',num2str(val)], 'Interpreter','none')
hold off

