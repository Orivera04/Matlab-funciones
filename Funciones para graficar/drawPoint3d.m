function varargout = drawPoint3d(varargin)
%DRAWPOINT3D draw 3D point on the current axis.
%
%   DRAWPOINT(X, Y, Z) will draw points defined by coordinates X and Y.
%   X and Y are N*1 array, with N being number of points to be drawn.
%   If coordinates of points lie outside the visible area, points are
%   not drawn.
%
%   DRAWPOINT(COORD) packs coordinates in a single [N*3] array.
%
%   DRAWPOINT(..., OPT) will draw each point with given option. OPT is a
%   string compatible with 'plot' model. 
%
%
%   H = DRAWPOINT(...) also return a handle to each of the drawn points.
%
%
%   ---------
%
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 18/02/2005.
%

%   HISTORY
%   04/01/2007: remove unused variables, and enhance support for plot
%       options


var = varargin{1};
if size(var, 2)==3
    px = var(:, 1);
    py = var(:, 2);
    pz = var(:, 3);
    varargin = varargin(2:end);
elseif length(varargin)<3
    error('wrong number of arguments in drawPoint3d');
else
    px = varargin{1};
    py = varargin{2};
    pz = varargin{3};
    varargin = varargin(4:end);
end

% force to draw markers and not lines
if isempty(varargin)
    varargin = {'o'};
end

% get display limits
lim = get(gca, 'xlim');
xmin = lim(1);
xmax = lim(2);
lim = get(gca, 'ylim');
ymin = lim(1);
ymax = lim(2);
lim = get(gca, 'zlim');
zmin = lim(1);
zmax = lim(2);

% check validity for display
ok = px>=xmin;
ok = ok & px<=xmax;
ok = ok & py>=ymin;
ok = ok & py<=ymax;
ok = ok & pz>=zmin;
ok = ok & pz<=zmax;

% plot only points inside the axis.
h = plot3(px(ok), py(ok), pz(ok), varargin{:});

if nargout>0
    varargout{1}=h;
end
