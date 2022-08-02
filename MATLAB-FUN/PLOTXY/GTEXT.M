function hh=gtext(string)
%GTEXT	Place text on a 2-D graph using a mouse.
%	GTEXT('string') displays the graph window, puts up a
%	cross-hair, and waits for a mouse button or keyboard key to be
%	pressed.  The cross-hair can be positioned with the mouse (or
%	with the arrow keys on some computers).  Pressing a mouse button
%	or any key writes the text string onto the graph at the selected
%	location.  
%
%	See also TEXT, GINPUT.

%	L. Shure, 12-01-88.
%	Revised: Charles D. Packard 3-8-89
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin ~= 1
   error('Not enough or too many input arguments.');
end
if ~isstr(string)
   error('Argument must be a string.')
end
[az el] = view;
if az ~= 0 | el ~= 90
	error('View must be two-dimensional.')
end
[r,c]=size(string);

h = [];
units = get(gca,'defaulttextunits');
set(gca,'defaulttextunits','data')
for rows=1:r
   [x,y] = ginput(1);
   ht = text(x,y,string(rows,:),'VerticalAlignment','baseline');
   set(ht,'units',units)
   h = [ht; h];
end
set(gca,'defaulttextunits',units)
if nargout > 0
   hh = h;
end
