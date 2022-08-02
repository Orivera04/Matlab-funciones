function stem(x,y,linetype)
%STEM	Plot discrete sequence data.
%	STEM(Y) plots the data sequence Y as stems from the x-axis
%	terminated with circles for the data value.
%	STEM(X,Y) plots the data sequence Y at the values specfied
%	in X.
%	There is an optional final string argument to specify a line-type
%	for the stems of the data sequence.  E.g. STEM(X,Y,'-.') or
%	STEM(Y,':').
%
%	See also PLOT, BAR, STAIRS.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

n = length(x);
if nargin == 1
	y = x(:)';
	x = 1:n;
	linetype = '-';
elseif nargin == 2
	if isstr(y)
		linetype = y;
		y = x(:)';
		x = 1:n;
	else
		x = x(:)';
		y = y(:)';
		linetype = '-';
	end
elseif nargin == 3
	x = x(:)';
	y = y(:)';
end
xx = [x;x;nan*ones(size(x))];
yy = [zeros(1,n);y;nan*ones(size(y))];
cax = newplot;
next = lower(get(cax,'NextPlot'));
hold_state = strcmp(next,'add') & strcmp('add',lower(get(gcf,'NextPlot')));
h = plot(x,y,'o',xx(:),yy(:),linetype);
c = get(gca,'colororder'); set(h,'color',c(1,:))
q = axis;hold on;h=plot([q(1) q(2)],[0 0]);set(h,'color',get(gca,'xcolor'))
if ~hold_state, set(cax,'NextPlot',next); end
