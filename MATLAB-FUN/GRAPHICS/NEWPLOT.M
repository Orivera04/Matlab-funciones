function ah = newplot()
%NEWPLOT Graphics M-file preamble to handle the NextPlot property.
%	H = NEWPLOT is a standard preamble command that is put at
%	the beginning of graphics M-file functions that draw graphs
%	using only low-level object creation commands. NEWPLOT
%	"does the right thing" in terms of determining which axes and/or
%	figure to draw the plot in, based upon the setting of the
%	NextPlot property of axes and figure objects, and returns a
%	handle to the appropriate axes.
%
%	The "right thing" is:
%
%	Open a new figure if the figure NextPlot is "New",
%	Clear and reset the current figure if figure NextPlot is "Replace",
%	Open a new axes if the axes NextPlot is "New",
%	Clear and reset the current axes if axes NextPlot is "Replace".
%
%	See also HOLD, ISHOLD, FIGURE, AXES.


%	L. Shure, 2-3-92, Revised 4-2-92 JNL
%	Copyright (c) 1984-94 by The MathWorks, Inc.

fh = gcf;
fig_state = lower(get(fh,'NextPlot'));
if strcmp(fig_state,'new');
	fh = figure;
elseif strcmp(fig_state,'replace');
	clf reset;
end

ah = gca;
ax_state = lower(get(ah,'NextPlot'));
if strcmp(ax_state,'new')
	ah = axes;
elseif strcmp(ax_state,'replace')
	cla reset;
end
