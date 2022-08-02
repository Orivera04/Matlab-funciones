function grid(opt_grid);
%GRID	Grid lines for 2-D and 3-D plots.
% 	GRID ON adds grid lines to the current axes.
% 	GRID OFF takes them off.
% 	GRID, by itself, toggles the grid state.
%
%	GRID sets the XGrid, YGrid, and ZGrid properties of
%	the current axes.
%
%	See also TITLE, XLABEL, YLABEL, ZLABEL, AXES, PLOT.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

ax = gca;

if (nargin == 0)
	if (strcmp(get(ax,'XGrid'),'off'))
		set(ax,'XGrid','on');
	else
		set(ax,'XGrid','off');
	end
	if (strcmp(get(ax,'YGrid'),'off'))
		set(ax,'YGrid','on');
	else
		set(ax,'YGrid','off');
	end
	if (strcmp(get(ax,'ZGrid'),'off'))
		set(ax,'ZGrid','on');
	else
		set(ax,'ZGrid','off');
	end
elseif (strcmp(opt_grid, 'on'))
	set(ax,'XGrid', 'on');
	set(ax,'YGrid', 'on');
	set(ax,'ZGrid', 'on');
elseif (strcmp(opt_grid, 'off'))
	set(ax,'XGrid', 'off');
	set(ax,'YGrid', 'off');
	set(ax,'ZGrid', 'off');
else
	error('Unknown command option.');
end
