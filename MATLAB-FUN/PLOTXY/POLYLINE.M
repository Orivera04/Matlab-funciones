function h = polyline(x,y,style,opt_sc)
%POLYLINE Basic line drawing primitive.
%       POLYLINE is obsolete, but provided for upward compatibility from
%       MATLAB 3.5.
%
%	POLYLINE(X,Y) draws the polyline whose X- and Y-coordinates
%	are in vectors X and Y.
%	POLYLINE(X,Y,'type') draws the line with the style and color
%	indicated by the text string.  See PLOT for a list of
%	style and color attributes.
%	POLYLINE(X,Y,'sc') interprets X and Y in screen-coordinates
%	where (0.0,0.0) is the lower-left corner of the screen and
%	(1.0,1.0) is the upper-right corner.  Otherwise, data-
%	coordinates are used.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

disp('This usage of polyline is obsolete and will be eliminated in future')
disp('versions.  Please use line instead.')
opt = 'data';
linestyle = '-';
if nargin == 3
        if strcmp(style,'sc')
                opt = 'norm';
	else
		linestyle = style;
        end
elseif nargin == 4
	if strcmp(opt_sc,'sc') | strcmp(opt_sc,'norm')
	        opt = opt_sc;
	else
		error('Invalid input argument.')
	end
        linestyle = style;
end
if isstr(x) | isstr(y)
	error('Input data must be numeric.')
end
if strcmp(opt,'norm')
        [xx,yy] = sc2dc(x,y);
else
        xx = x; yy = y;
end
[a,b] = colstyle(linestyle);
cax = newplot;
next = lower(get(cax,'NextPlot'));
hold_state = ishold;
if ~hold_state & strcmp(opt,'norm')
	axis([0 1 0 1]);
	if length(get(gca,'children')) == 0
		set(gca,'box','on')
	end
end
hh = line(xx,yy,'Clipping','off');
if ~isempty(a), status = set(hh,'linestyle',a); end
if ~isempty(b), status = set(hh,'color',b); end
if nargout == 1
        h=hh;
end

