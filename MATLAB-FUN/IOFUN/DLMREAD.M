function m=dlmread(filename, dlm, r, c, rng)
%DLMREAD Read a ASCII delimited file into a matrix.
%
% 	M = DLMREAD(filename, dlm, r, c, rng) reads ASCII delimited format filename
%	and returns the matrix M, using the ASCII character dlm, optionally 
%	starting at offset r,c.
%	rng is used to only import a range 
%

%		Brian M. Bourgault 10/22/93
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%

	%
	% test for proper filename
	%
	if ~isstr(filename)
		error('delread: Filename must be a string argument!');
	end

	%
	% check/set row,col offsets
	%
	if ~exist('r')
		r = 0;
	end
	if ~exist('c')
		c = 0;
	end

	%
	% delimiter defaults to Comma for CSV
	%
	if ~exist('dlm')
		dlm = ',';
	end

	%
	% get the upper-left and bottom-rignt cells
	% of the range to read into MATLAB
	%
	if exist('rng')
		if ~isstr(rng)
			ulc = rng(1:2);
			brc = rng(3:4);
		else
			x = str2rng(rng)
			ulc = x(1:2);
			brc = x(3:4);
		end
	else
		all = 1;
		rng = [ 0 0 ];
		ulc = [0 0];
		brc = [0 0];
	end

	%
	% open the file 
	%
	fid = fopen(filename,'r');
	if fid == (-1)
		error(['dlmread: Could not open file filename ']);
	end

	%
	% Read delimited format 
	%
	eol = 10;         % End Of Line char
	loc = [1 1];      % starting location of return matrix
	line = fgets(fid); % get the 1st line, if any...
	%
	% read till eof
	%
	while(line ~= [ -1 ])
		i = 1;
		j = 1;
		while(i <= length(line))
			%
			% read chars from line, parsing delimiters & numbers
			%
			num = [];
			j = 1;
			while(line(i) ~= dlm & line(i) ~= eol)
				%
				% build number string from characters on the line
				%
				num(j) = line(i);
				i = i + 1;	% overall line index
				j = j + 1;	% number string index
			end

			%
			% found a delimiter or <eol>
			%
			if(all | ((loc >= ulc) & (loc <= brc)))
				if( num ~= [])
					num(j) = 0; % null terminate string
					y = str2num(setstr(num));
					m(loc(2)+r, loc(1)+c) = y';
				else 	
					% no number found between delimiters
					m(loc(2)+r, loc(1)+c) = 0;
				end
			end

			if(line(i)  == dlm)
				% delimiter, set location to next row and get next line
				loc(1) = loc(1) + 1;
				i = i + 1;
			else
				if(line(i) == eol)
					% eol, set location to next row and get next line
					loc(2) = loc(2) + 1;
					loc(1) = 1;
					i = i + 1;
				end
			end
		end
		% get next line of file
		line = fgets(fid); 
	end
	% close file
	fclose(fid);
