function h = gcf()
%GCF	Get current figure handle.
%	H = GCF returns the handle to the current figure. The current
%	figure is the figure (graphics window) that graphics commands
%	like PLOT, TITLE, SURF, etc. draw to if issued.
%
%	Use the commands FIGURE to change the current figure
%	to a different figure, or to create new ones.
%
%	See also FIGURE, CLOSE, CLF, GCA.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

h = get(0,'CurrentFigure');
