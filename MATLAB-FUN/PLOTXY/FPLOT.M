function [x0,y0] = fplot(fname,lims,arg3,arg4)
%FPLOT	Plot a function.
%	FPLOT(FNAME,LIMS) plots the function specified by the string variable
%	FNAME between the x-axis limits specified by LIMS = [XMIN XMAX].
%	LIMS = [XMIN XMAX YMIN YMAX] gives optional y-axis plotting limits.
%
%	The function FNAME should agree with MATLAB's columnwise standard.
%	For example, if FNAME is the function denoted by f = [f1(x) f2(x)],
%	then for input [x1 x2 x3]', the function should return the matrix
%
%		f1(x1)	f2(x1)
%	f(x) =	f1(x2)	f2(x2)
%		f1(x3)	f3(x3)
%
%	Alternatively, FNAME may be an eval-able string with variable x, such
%	as 'sin(x)', 'diric(x,10)' or '[sin(x),cos(x)]'.
%
%	FPLOT accepts two optional arguments, MARKER and TOL.
%	MARKER is a string that specifies the marker type to be used in the
%	plot.  The default type is '-'.  In addition to standard plot types,
%	FPLOT accepts '-+', '-x', '-o', '-*' (or '+-', 'x-', 'o-', and '*-').
%	TOL is the relative error tolerance.  The default is 2e-3.  The
%	maximum number of x steps is (1/TOL)+1.
%
%       [X,Y] = fplot(FNAME,LIMS,...) returns the abscissae and ordinates used
%	to plot FNAME in the column vector X and the columns of matrix Y.
%
%	Examples:
%	fplot('sin',[0 4*pi])
%	fplot('sin(x)',[0 4*pi],'-+')
%	fplot('[sin(x),cos(x)]',[0 4*pi],'-x')
%	fplot('abs(exp(-j*x*(0:9))*ones(10,1))',[0 2*pi],'-o')
%	fplot('tan',[-2*pi 2*pi -2*pi 2*pi],'-*')
%	fplot('[tan(x),sin(x),cos(x)]',[-2*pi 2*pi -2*pi 2*pi])
%	fplot('sin(1 ./ x)', [0.01 0.1],1e-3)

%	The FPLOT function begins with a minimum step of size (XMAX-XMIN)*TOL.
%	The step size is subsequently doubled whenever the relative error
%	between the linearly predicted value and the actual function value is
%	less than TOL.

%       Mark W. Reichelt 6-2-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Handle the following arg sequences.
% fname,lims,[marker],[tol]

if nargin < 2
  error('at the least, fname and X-axis limits must be specified.');
end

default_marker = '-';
default_tol = 2e-3;

if nargin == 3
  if isstr(arg3)
    marker = arg3;
    tol = default_tol;
  else
    marker = default_marker;
    tol = arg3;
  end
elseif nargin == 4
  if isstr(arg3)
    marker = arg3;
    tol = arg4;
  else
    marker = arg4;
    tol = arg3;
  end
end

if isempty(marker)
  marker = default_marker;
end
if isempty(tol)
  tol = default_tol;
end

% Form call string -- function name if no characters less than ascii 48
if ~any(fname < 48) & ~strcmp(fname,'x')
  fcall = [fname,'(x)'];
else
  fcall = fname;
end

% compute the x duration and minimum x step
xmin = min(lims(1:2)); xmax = max(lims(1:2));
minstep = (xmax - xmin) * tol;
try = minstep;

% compute the first two points
x = xmin; y = eval(fcall);
xx = x;
x = xmin+minstep; y(2,:) = eval(fcall);
xx(2) = x;

% compute a constant ytol if y limits are given
if length(lims) == 4
  ymin = min(lims(3:4)); ymax = max(lims(3:4));
  ylims = 1;
else
  J = find(finite(y));
  if isempty(J)
    ymin = 0; ymax = 0;
  else
    ymin = min(y(J)); ymax = max(y(J));
  end
  ylims = 0;
end
ytol = (ymax - ymin) * tol;

I = 2;
while xx(I) < xmax
  I = I+1;

  try = min(2*try, xmax-xx(I-1));
  x = xx(I-1) + try;
  y(I,:) = eval(fcall);
  ylin = y(I-1,:) + (x-xx(I-1)) * (y(I-1,:)-y(I-2,:)) / (xx(I-1)-xx(I-2));

  while any(abs(y(I,:) - ylin) > ytol) & (try > minstep)
    try = max(minstep,0.5*try);
    x = xx(I-1) + try;
    y(I,:) = eval(fcall);
    ylin = y(I-1,:) + (x-xx(I-1)) * (y(I-1,:)-y(I-2,:)) / (xx(I-1)-xx(I-2));
  end

  if ~ylims
    J = find(finite(y(I,:)));
    if ~isempty(J)
      ymin = min(ymin,min(y(I,J))); ymax = max(ymax,max(y(I,J)));
      ytol = (ymax - ymin) * tol;
    end
  end

  xx(I) = x;
end

if nargout == 0
  if strcmp(marker,'-+') | strcmp(marker,'+-') | ...
	strcmp(marker,'-x') | strcmp(marker,'x-') | ...
	strcmp(marker,'-o') | strcmp(marker,'o-') | ...
	strcmp(marker,'-*') | strcmp(marker,'*-')
    plot(xx,y,marker(1),xx,y,marker(2));
  else
    plot(xx,y,marker)
  end
  set(gca,'XLim',[xmin xmax]);
  if ylims
    set(gca,'YLim',[ymin ymax]);
  end
else
  x0 = xx.'; y0 = y;
end
