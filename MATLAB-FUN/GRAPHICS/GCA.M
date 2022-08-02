function h = gca()
%GCA	Get current axis handle.
%	H = GCA returns the handle to the current axis. The current
%	axis is the axis that graphics commands like PLOT, TITLE,
%	SURF, etc. draw to if issued.
%
%	Use the commands AXES or SUBPLOT to change the current axis
%	to a different axis, or to create new ones.
%
%	See also AXES,SUBPLOT,DELETE,CLA,HOLD,GCF.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

h = get(get(0,'CurrentFigure'),'CurrentAxes');
