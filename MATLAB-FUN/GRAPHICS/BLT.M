function output_colors = blt( object, contrastColor, colors )
%BLT Set line and text objects to Black or White.
%	BLT is an M-file that will recursively change the color
%	properties of the given object, or the current Figure window by 
%	default, and its children to give proper black on white or white 
%	on blackhardcopy output. The color of the line/text object depends
%	on the contrastColor RGB triplet supplied, or the Figure's color
%	attribute if none is supplied.
%
%	Returned are the colors of all line and text objects found while
%	traversing the tree of objects. This can be used to restore the
%	previous colors to all line and text objects. 
%
%	See also PRINT.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

%
% input is a) none  b) just colors  c) object and contrastColor  d) everything
%

%
% if only 1 input, it should be nx3 matrix of RGB values
%
if nargin == 1
	if isempty(object)
		return
	end
	colors = object;
	if size(colors,2) ~= 3
		error('Argument must be a 3-column matrix of RGB triplets.');
	end
end

%
% assume current figure if given no input or only colors
%
if nargin < 2
	object = gcf;
	contrastColor = get(gcf,'color');
end

%
% get descendents in family tree of objects
%
kids = get(object, 'Children')';

if (nargin == 2) | (nargin == 0)

	%
	% all current colors will be stored for return
	%
	colors = [];
	old_colors = [];

	if  strcmp(get(object,'type'), 'axes')
		for whichAxis = 'xyz'
			c = get(object, [ whichAxis 'color' ]);
			old_colors = [ old_colors; c];
	
			if (3 ~= sum(c == [1 1 1])) & (3 ~= sum(c == [0 0 0]))
				%
				% if contrastColor color converted to NTSC gray scale is close 
				% to white, set line/text to black, else white
				%
				if (contrastColor * [.3 ; .59 ; .11]) > .75
					set(object, [ whichAxis 'color' ], 'black');
				else
					set(object, [ whichAxis 'color' ], 'white');
				end
			end
		end


	%
	% need to replace current colors of line/text objects
	%
	elseif strcmp(get(object,'type'), 'line') | strcmp(get(object,'type'), 'text')
		c = get(object, 'color');
		old_colors = [colors; c];

		%
		% is line/text object not black or white
		%
		if (3 ~= sum(c == [1 1 1])) & (3 ~= sum(c == [0 0 0]))
			%
			% if contrastColor color converted to NTSC gray scale is close 
			% to white, set line/text to black, else white
			%
			if (contrastColor * [.3 ; .59 ; .11]) > .75
				set(object, 'color', 'black');
			else
				set(object, 'color', 'white');
			end
		end

	elseif strcmp(get(object,'type'), 'surface') 
		%
		% see if it has the attributes of a mesh plot
		%
		c = get(object, 'Facecolor');
		if ( (1 == size(c,1)) & (3 == size(c,2)) ...
		  & strcmp('flat', get(object, 'EdgeColor')) )
			%
			% give meshes a grid color that contrasts
			%
			if (contrastColor * [.3 ; .59 ; .11]) > .75
				set(object, 'EdgeColor', 'black');
			else
				set(object, 'EdgeColor', 'white');
			end
			
			%
			% hold onto handle of this particular mesh object
			% so we can replace flat shading 
			%
			old_colors = [colors; [object NaN NaN] ];
		else
			% space holder
			old_colors = [colors; [NaN NaN NaN] ];		  
		end

	end

	for obj = kids
		old_colors = [ old_colors ; blt(obj, contrastColor) ];
	end

else
	%
	% need to set the object's color back to what it was, the old color
	% was passed in 
	%
	old_colors = colors;

	if  strcmp(get(object,'type'), 'axes')
		for whichAxis = 'xyz'
			set(object, [ whichAxis 'color' ], old_colors(1,:) );
			old_colors(1,:) = [];
		end

	elseif strcmp(get(object,'type'), 'line') | strcmp(get(object,'type'), 'text')
		set(object, 'color', old_colors(1,:) );
		old_colors(1,:) = [];

	elseif strcmp(get(object,'type'), 'surface') 
		%
		% see if it is one of the mesh objects we turned from flat to colored
		%
		if object == old_colors(1,1)
			set(object, 'Edgecolor', 'flat')
		end
		old_colors(1,:) = [];

	end

	for obj = kids
		old_colors = blt(obj, contrastColor, old_colors);
	end

end

%
% echo the colors we changed, so a future call to blt can use 
% swap the colors back, only if user asked for the output or set
% ans if using all default input
%
if (nargout == 1) | (nargin == 0)
	output_colors = old_colors;
end
