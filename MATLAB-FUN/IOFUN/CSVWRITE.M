function csvwrite(filename, m, dlm, r, c)
%CSVWRITE Write a Comma Separated Value file from a matrix.
%	CSVWRITE(filename, m, dlm, r, c) writes matrix m out to filename, 
%	in Comma Separated Value format, optionally starting at offset r,c.
%

%	Brian M. Bourgault 10/22/93
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%

	%
	% test for proper filename
	%
	if ~isstr(filename)
		error('csvwrite: Filename must be a string argument!');
		return
	end

	%
	% Call dlmwrite with a comma as the delimiter
	%
	if ~exist('r')
		r = 0;
	end
	if ~exist('c')
		c = 0;
	end
	if ~exist('rng')
		m=dlmwrite(filename, ',', r, c);
	else
		m=dlmwrite(filename, ',', r, c, rng);
	end
