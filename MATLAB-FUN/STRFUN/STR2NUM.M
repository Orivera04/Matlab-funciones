function xunique = str2num(sunique)
%STR2NUM String to number conversion.
%	X = STR2NUM(S)  converts the string S, which should be an
%	ASCII character representation of a numeric value, to MATLAB's
%	numeric representation.  The string may contain digits, a decimal
%	point, a leading + or - sign, an 'e' preceeding a power of 10 scale
%	factor, and an 'i' for a complex unit.
%
%	STR2NUM converts a string matrix representation of a matrix of
%	numbers to a numeric matrix. For example,
%	    
%	     A = ['1 2'         str2num(A) => [1 2;3 4]
%	          '3 4']
%
%	If the string S does not represent a valid number or matrix,
%	STR2NUM(S) returns the empty matrix.
%
%	See also NUM2STR, HEX2NUM.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

if ~isstr(sunique)
   error('Requires string input.')
end
[aunique,bunique] = size(sunique);
if (aunique > 1),
	if ~any(any(sunique == 91 | sunique == 93)),    % String does not contain brackets

		sunique = [[91;32*ones(aunique-1,1)],sunique,ones(aunique,1)*59,[32*ones(aunique-1,1);93]]';

	elseif ~any(sum(sunique(1:aunique-1,:) == 59)), % No ;'s in non-last rows

		sunique = [sunique,[ones(aunique-1,1)*59;32]]';

	else,                               % Put ;'s where appropriate
		spost = ones(aunique,1)*32;
		for i = 1:aunique-1,
			last = find(fliplr(sunique(i,:)) ~= 32);
			if sunique(i,bunique-last(1)+1) ~= ';',
				spost(i) = 59;
			end
		end
		sunique = [sunique,spost]';
	end
end

xunique = eval(sunique,'[]');

if isstr(xunique)
   xunique = [];
end
