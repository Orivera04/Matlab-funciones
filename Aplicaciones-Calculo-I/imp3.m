function out=imp3(varargin)
%IMPLICITPLOT3D 3-D implicit plot
% IMPLICITPLOT3D(eqstring, val, xvar, yvar, zvar, xmin, xmax, 
% ymin, ymax, zmin, zmax) plots a an implicit equation
% eqstring=val, where eqstring is a symbolic function of (symbolic)
% variables xvar, yvar, and zvar in the indicated ranges, and val is a number.
% If xvar, yvar, and zvar are not specified, it is assumed they are 
% 'x', 'y',and 'z', respectively. 
% The optional parameter plotpoints (added at the end)
% gives the number of steps in each direction between plotting points.
%
% Example: implicitplot3d('x^2+y^2+z^2', 5, -3, 3, -3, 3, -3, 3)
% plots the sphere 'x^2+y^2+z^2=5' with 'x', 'y', and 'z' 
% going from -3 to 3.
% implicitplot3d('x^2+y^2+z^2', 5, -3, 3, -3, 3, -3, 3, 30)
% does the same with higher accuracy.
% written by Jonathan Rosenberg, 7/30/99

if nargin<8, error('not enough input arguments -- need at least expression string, value, xmin, xmax, ymin, ymax, zmin, zmax'); end

if nargin==10, error('impossible number of input arguments'); end

if nargin>12, error('too many input arguments'); end

% Default value of plotpoints is 10.
plotpoints=10;

eqstring=varargin{1}; val=varargin{2};

% Next, handle case where variable names are missing.
if nargin<10, xvar='x'; yvar='y'; zvar='z'; 
  xmin=varargin{3}; xmax=varargin{4}; 
  ymin=varargin{5}; ymax=varargin{6}; 
  zmin=varargin{7}; zmax=varargin{8}; 
  if nargin==9, plotpoints=varargin{9}; end
end
% Next, handle case where variable names are included.
if nargin>10, xvar=varargin{3}; yvar=varargin{4}; zvar=varargin{5}; 
  xmin=varargin{6}; xmax=varargin{7}; 
  ymin=varargin{8}; ymax=varargin{9}; 
  zmin=varargin{10}; zmax=varargin{11}; 
  if nargin==12, plotpoints=varargin{12}; end
end

F=inline(vectorize(eqstring,xvar,yvar,zvar));
[X Y]= meshgrid(xmin:(xmax-xmin)/plotpoints:xmax, ymin:(ymax-ymin)/plotpoints:ymax);

%% Go through zvalues one at a time. For each one, plot corresponding
%% contourplot in x and y, with that z-value.  We could use "contour" 
%%    (see commented lines) except that
%% it makes a "shadow", so we copy some of the code of "contour".

for z=zmin:(zmax-zmin)/plotpoints:zmax
%    [c,h]=contour(X,Y,F(X,Y,z), [val val],'-');
%      for counter=1:length(h)
%      line(get(h(counter),'XData'),get(h(counter),'YData'),0*get(h(counter),'XData')+z);
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
     line('XData',xdata,'YData',ydata,'ZData',zdata); 
     %%hold on;
	  i = nexti;
	end
end
view(3)
xlabel(xvar)
ylabel(yvar)
zlabel(zvar)
title([eqstring,' = ',num2str(val)], 'Interpreter','none')
hold off

