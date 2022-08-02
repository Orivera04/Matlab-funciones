function hold(opt_hold_state);
%HOLD	Hold the current graph.
% 	HOLD ON holds the current plot and all axis properties so that
%	subsequent graphing commands add to the existing graph.
% 	HOLD OFF returns to the default mode whereby PLOT commands erase 
% 	the previous plots and reset all axis properties before drawing 
%	new plots.
% 	HOLD, by itself, toggles the hold state.
% 	HOLD does not affect axis autoranging properties.
%
%	Algorithm note:
%	HOLD ON sets the NextPlot property of the current figure and
%	axes to "add".
%	HOLD OFF sets the NextPlot property of the current axes to
%	"replace".
%
%	See also ISHOLD, NEWPLOT, FIGURE, AXES.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

ax = gca;
nexta = lower(get(ax,'NextPlot'));
nextf = lower(get(gcf,'NextPlot'));
hold_state = strcmp(nexta,'add') & strcmp(nextf,'add');
if(nargin == 0)
	if(hold_state)
		set(ax,'NextPlot','replace');
		disp('Current plot released');
	else
		set(ax,'NextPlot','add');
		disp('Current plot held');
	end
elseif(strcmp(opt_hold_state, 'on'))
	set(gcf,'NextPlot','add');
	set(ax,'NextPlot', 'add');
elseif(strcmp(opt_hold_state, 'off'))
	set(ax,'NextPlot', 'replace');
else
	error('Unknown command option.');
end
