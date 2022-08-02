function object = gco(figure)
%GCO    Handle of current object.
%	OBJECT = GCO returns the current object in
%	the current figure.
%
%	OBJECT = GCO(FIGURE) returns the current object
%	in figure FIGURE.
%
%	The current object for a given figure is the last
%	object clicked on with the mouse.


%	Copyright (c) 1984-94 by The MathWorks, Inc.

if isempty (get (0, 'Children')),
	object = [];
	return;
end;

if(nargin == 0)
	figure = get(0,'CurrentFigure');
end

object = get( figure, 'CurrentObject');
