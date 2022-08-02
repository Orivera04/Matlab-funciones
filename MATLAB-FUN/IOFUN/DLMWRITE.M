function dlmwrite(filename, m, dlm, r, c)
%DLMWRITE Write a matrix to an ASCII Delimited File.
%	DLMWRITE(filename, m, dlm, r, c) writes matrix m out to filename, 
%	in ASCII delimited format, using dlm as the delimiter,
%	optionally starting at offset r,c.


%		Brian M. Bourgault 10/22/93
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%
	%
	% test for proper filename
	%
	if ~isstr(filename),
		error('dlmwrite: Filename must be a string argument!');
	end;

	if nargin < 2
		error('dlmwrite: Requires first 2 arguments.');
	end

	%
	% delimiter defaults to Comma for CSV
	%
	if ~exist('dlm')
		dlm = ',';
	end

	%
	% open the file Lotus uses Little Endian Format ONLY
	%
	fid = fopen(filename ,'wb');
	if fid == (-1)
		error(['dlmwrite: Could not open file ' filename]);
	end
	%
	% check for row,col offsets
	%
	if ~exist('r')
		r = 0;
	end
	if ~exist('c')
		c = 0;
	end
	
	%
	% dimensions size of matrix
	%
	[ r c ] = size(m);
	
	%
	% start dumping the array, for now number format float
	%
	for i = 1:r
		for j = 1:c
			if(m(i,j) ~= 0)
				str = num2str(m(i,j));
				fwrite(fid, str, 'uchar');	
			end
			if(j < c)
				fwrite(fid, dlm, 'uchar');	
			end
		end
		fwrite(fid, 10, 'char'); % this may \r\n for DOS 
	end

	% close files
	fclose(fid);
