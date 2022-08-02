%DRAWNOW Complete any pending drawing.
%	DRAWNOW "flushes the event queue" and forces MATLAB to
%	update the screen. 
%
%	There are four events that cause MATLAB to flush the event
%	queue and draw the screen:
%
%	- a return to the MATLAB prompt
%	- hitting a PAUSE statement
%	- executing a GETFRAME command
%	- executing a DRAWNOW command
%
%	DRAWNOW('DISCARD') causes the information to be updated as if
%	the queued events were flushed, but doesn't actually flush
%	them.  This is needed for printing hardcopy when the figure
%	property InvertHardcopy is on.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
