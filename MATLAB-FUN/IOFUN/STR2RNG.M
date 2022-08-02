function m=str2rng(str)
%STR2RNG Convert a spreadsheet range string to a numeric array.
%

%	Brian M. Bourgault 10/22/93
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%
	if ~isstr(str)
		error('wk1read: range string argument!');
	end

	m = [];

	% convert to upper case
	str = upper(str);
	% parse the upper-left and bottom-right cell locations
	for i = 1:length(str)-1
		if(str(i:i+1) == '..')
			ulc = str(1:i-1);
			brc = str(i+2:length(str));
		end
	end

	if(i == length(str)) % could not find '..'
		return
	end

	% get upper-left col
	if (ulc(1) >= 'A' & ulc(1) <= 'Z')
		topl(1) = (ulc(1) - 'A') + 1;
	else
		return
	end

	if (ulc(2) >= 'A' & ulc(2) <= 'Z')
		topl(1) = topl(1) * (ulc(2) - 'A' + 1) + 26;
		topl(2) = str2num(ulc(3:length(ulc)));
	else
		topl(2) = str2num(ulc(2:length(ulc)));
	end


	% get bottom-right col
	if (brc(1) >= 'A' & brc(1) <= 'Z')
		botr(1) = (brc(1) - 'A') + 1;
	else
		error('wk1read: invalid range string argument!');
	end

	if (brc(2) >= 'A' & brc(2) <= 'Z')
		botr(1) = botr(1) * (brc(2) - 'A' + 1) + 26;
		botr(2) = str2num(brc(3:length(brc)));
	else
		botr(2) = str2num(brc(2));
	end

	m=[topl botr];
