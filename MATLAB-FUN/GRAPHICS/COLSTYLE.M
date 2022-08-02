function [style,color] = colstyle(A)
%COLSTYLE  Parse color and style from string for graphics.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin < 1
	error('Requires one input argument.');
end
a = A;
if ~isstr(a)
	error('Argument must be a string.');
end
if length(a) > 4
	error('Invalid color and style string.')
end
valid_colors = 'ymrgbwkc'; % and don't forget c followed by an integer
valid_styles = '-.:xo*+'; % don't forget -- and -.

color = [];
for i = 1:length(a)
	k = find(a(i) == valid_colors);
	if ~isempty(k)	% found a color - if they give extra colors, too bad
		color = a(i);
		if (color == 'c') % see if there's an integer after it
			if length(a) > i  % not end of string
				next = abs(a(i+1));
				if next > 47 & next < 58 % a digit
					color = [color a(i+1)];
					if length(a) > i+1 % another character
						next1 = abs(a(i+2));
						if next1 > 47 & next1 < 58 % a digit
							color = [color a(i+2)];
							a(i+2) = [];
						end
					end
					a(i+1) = [];
				end
			end
		end
		a(i) = [];
		break;
	end
end

style = [];
for i = 1:length(a)
	k = find(a(i) == valid_styles);
	if ~isempty(k) % found a style
		style = a(i);
		if (style == '-') % see if this is followed by - or .
			if length(a) > i % not end of string
				next = a(i+1);
				if next == '-' | next == '.'
					style = [style next];
				end
				break;
			end
		end
	end
end
if length(style)+length(color) ~= length(A)
	error('Invalid color and style string.')
end
