function varargout=grid2(varargin)

%GRID2 - Adds grid lines to the plot
%   GRID2 adds grid lines to the plot, which can be modified with the
%   general line specifications.
%   Usage:
%   GRID2(axishandle,lineattribute,value,...)
%   Example:
%   GRID2(gca,'r:') draws a red dotted grid on the current axes.
%   GRID2(gca,'r','linewidth',3) draws a red grid with thick lines.

% less than two arguments => exit
if nargin<2 help('grid2'); return; end

% get handle and save plot state
h=varargin{1};
np=get(h,'nextplot');

% get boundaries
axes(h); grid off; set(h,'nextplot','add');
x=get(h,'xtick'); y=get(h,'ytick');
xx=x(2:end-1); yy=y(2:end-1);

% generate grid lines
gx=[[xx;xx],repmat([min(x) max(x)]',1,length(yy))];
gy=[repmat([min(y) max(y)]',1,length(xx)),[yy;yy]];
gn=ones(1,size(gx,2)).*NaN;
gx=[gx;gn]; gx=gx(:);
gy=[gy;gn]; gy=gy(:);

% plot grid
if nargout>0
    p = plot(gx,gy,varargin{2:end});
    varargout{1} = p;
else
    plot(gx,gy,varargin{2:end});
end

% set old plot state
set(h,'nextplot',np);
