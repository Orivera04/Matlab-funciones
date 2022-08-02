function cinvert(object)
%CINVERT Invert black and white objects for nice printer output.
%	CINVERT is an M-file that will recursively change the color
%	properties of the given object, or the current Figure window by 
%	default, and its children to give proper black on white hardcopy 
%	output.
%
%	When printing on white paper it looks nicer, and uses less
%	ink/toner, to plot MATLAB graphics on a white background; instead
%	of the default black background used on screen. Since the background
%	changes, some children of the Figure also need to be inverted
%	to stay visible. Non black or white objects will not have their
%	colors changed. 
%
%	See value of 'params' in this M-file for list of what properties 
%	of the different object types are to be inverted.
%
%	See also PRINT.

%	Copyright (c) 1984-94 by The MathWorks, Inc.


%
%assume current figure if no input given
%
if (nargin == 0)
	object = gcf;
end

%
%properties of current object that maintain color information
%
if strcmp(get(object,'type'), 'axes')
	%color of each axis may need to change
	params = [ ['Color ']' ['XColor']' ['YColor']' ['ZColor']'];

	%setting axis color affects a corrosponding label, so afterwards
	%need to put text color back to the way they are now
	axisLabels = [get(object,'xlabel') get(object,'ylabel') ...
		          get(object,'zlabel') get(object,'title') ];
	tc = [];
	for whichLabel = axisLabels
		tc = [ tc ; get(whichLabel, 'color') ];
	end

elseif strcmp(get(object, 'type'), 'uicontrol')
	params = [ ['BackgroundColor']' ['ForegroundColor']' ];

elseif strcmp(get(object, 'type'), 'surface')
	%mesh plots have flat face colors that match background
	c = get(object,'FaceColor');
	if (1 == size(c,1)) & (3 == size(c,2)) 
		params = [ ['FaceColor']' ['EdgeColor']' ];
	else
		params = [] ;
	end

elseif strcmp(get(object, 'type'), 'patch')
	params = [ ['FaceColor']' ['EdgeColor']' ];

elseif strcmp(get(object, 'type'), 'image')     ...
	| strcmp(get(object, 'type'), 'uicontrol')  ...
	| strcmp(get(object, 'type'), 'uimenu')
	%there are no parameters to modify when inverting
	params = [];

else
	params = ['Color']';
end

%
%for looping on a matrix sets p to one column at a time
%
for p = params
	p = p';
	c = get(object, p);
	if ~isstr(c)
		if 3 == sum(c == [1 1 1]) %white
			set(object, p, 'black');
		elseif 3 == sum(c == [0 0 0]) %black
			set(object, p, 'white');
		end
	end
end

%Set color of text objects actings as labels back to what they where.
if strcmp(get(object,'type'), 'axes')
	if ~isempty(axisLabels)
		% need to put text color back
		for l = 1:length(axisLabels)
			set( axisLabels(l), 'color', tc(l,:) );
		end
	end
end

%
%recursion ends when no more kids
%need to change color of text objects used for axis labels
%
kids = get(object, 'Children')';
if  strcmp(get(object,'type'), 'axes')
	kids = [ kids get(object,'xlabel') get(object,'ylabel') ...
		get(object,'zlabel') get(object,'title') ];
end
for obj = kids
	cinvert(obj)
end


