function varargout = drawCenteredEdge(point, len, theta, varargin)
%DRAWCENTEREDEDGE Draw an edge centered on a point
%   
%   usage :
%   drawCenteredEdge(PT, L, THETA)
%   Draw an edge centered on point PT, with length L, and orientation
%   THETA.
%
%   drawCenteredEdge(..., OPT), with OPT being a set of pariwise options,
%   can specify color, line width and so on ...
%
%   H = drawCenteredEdge(...) return handle(s) to created edges(s)
%
%
%   ---------
%
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 05/08/2005.
%

%   HISTORY


% default values for parameters
options = {'color', [0 0 1], 'linewidth', 1};
h = [];

% process input variables
NP = size(point, 1);
NL = size(len, 1);
ND = size(theta, 1);
N  = max([NP NL ND]);

if N>1 && NP==1
    point = repmat(point, [N 1]);
end
if N>1 && NL==1
    len = repmat(len, [N 1]);
end
if N>1 && ND==1
    theta = repmat(theta, [N 1]);
end


% extract drawing options
options = varargin(:);

% center point
xc = point(:,1);
yc = point(:,2);

% compute starting and ending points
x1 = xc - len.*cos(theta)/2;
x2 = xc + len.*cos(theta)/2;
y1 = yc - len.*sin(theta)/2;
y2 = yc + len.*sin(theta)/2;


% draw the edges
for i=1:size(x1, 1)
    h(i) = line([x1(i) x2(i)], [y1(i) y2(i)]);
end

% apply style to edges
if length(options)>0
    for i=1:length(h)
        set(h(i), options{:});
    end
end

% process output arguments
if nargout>0
    varargout{1}=h;
end
