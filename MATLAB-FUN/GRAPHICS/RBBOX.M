%RBBOX	Rubberband box.
%	RBBOX(RECTI, XY) tracks a rubberband box in the current
%	figure, initialized with box RECTI, and starting the tracking at
%	the point XY.  The mouse button must be held down when RBBOX is
%	called.  RBBOX returns with the mouse up button event.  As a 
%	result, RBBOX can be used in an M-file, along with 
%	WAITFORBUTTONPRESS, to control dynamic behavior.
%	RECTI and XY are in the units of the current figure.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.

