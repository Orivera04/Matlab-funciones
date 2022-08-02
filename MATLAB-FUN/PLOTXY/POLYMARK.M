function h = polymark(x,y,style,opt_sc)
%POLYMARK  Basic marker drawing primitive.
%       POLYMARK is obsolete, but provided for upward compatibility from
%       MATLAB 3.5.
%
%	POLYMARK(X,Y) draws polymarkers at the X- and Y-coordinates
%	in vectors X and Y.
%	POLYMARK(X,Y,'type') uses the marker style and color
%	indicated by the text string.  See PLOT for a list of
%	style and color attributes.
%	POLYMARK(X,Y,'sc') interprets X and Y in screen-coordinates
%	where (0.0,0.0) is the lower-left corner of the screen and
%	(1.0,1.0) is the upper-right corner.  Otherwise, data-
%	coordinates are used.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

disp('This usage of polymark is obsolete and will be eliminated in future')
disp('versions.  Please use line instead.')
opt = 'data';
linestyle = '*';
if nargin == 3
	if strcmp(style,'sc')
		opt = 'norm';
	else
		linestyle = style;
	end
elseif nargin == 4
        if strcmp(opt_sc,'sc')
                opt = opt_sc;
        else
                error('Invalid input argument.');
        end
	linestyle = style;
end
[a,b] = colstyle(linestyle);
if isstr(x) | isstr(y)
        error('Input data must be numeric.')
end
if strcmp(opt,'norm')
	[xx,yy] = sc2dc(x,y);
else
	xx = x; yy = y;
end
cax = newplot;
next = lower(get(cax,'NextPlot'));
hold_state = ishold;
if ~hold_state & strcmp(opt,'norm')
        axis([0 1 0 1]);
	if length(get(gca,'children')) == 0, set(gca,'box','on'),end
end
hh = line(xx,yy,'Clipping','off');
if isempty(a), a = '*'; end
if ~isempty(a), status = set(hh,'linestyle',a); end
if ~isempty(b), status = set(hh,'color',b); end
if nargout == 1
	h = hh;
end
