function wk1write(filename, m, r, c)
%WK1WRITE Write a matrix m out to a Lotus WK1 Spreadsheet file format.
%	WK1WRITE(filename, m, r, c) writes matrix m into a Lotus WK1 spreadsheet file,
%	optionally starting at offset r,c.
%

%	Brian M. Bourgault 10/22/93
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%
	%
	% include WK1 constants
	%
	wk1const

	%
	% test for proper filename
	%
	if ~isstr(filename),
		error('wk1write: Filename must be a string argument!');
	end;

	if nargin < 2
		error('wk1write: Requires first 2 arguments.');
	end

	%
	% open the file Lotus uses Little Endian Format ONLY
	%
	fid = fopen([filename '.wk1'],'wb', 'l');
	if fid == (-1)
		error(['wk1write: Could not open file ' filename '.wk1']);
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
	% Lotus WK1 BOF
	%
	fwrite(fid, LOTWK1BOFSTR,'uchar');
	
	%
	% Lotus WK1 dimensions size of matrix
	%
	[ r c ] = size(m);
	LOTrng = [0 0 c r];
	wk1wrec(fid, LOTDIMENSIONS, 0);
	fwrite(fid, LOTrng, 'ushort');

	%
	% Lotus WK1 cpi
	%
	wk1wrec(fid, LOTCPI, 0);
	fwrite(fid, [0 0 0 0 0 0], 'uchar');
	
	%
	% Lotus WK1 calcount
	%
	wk1wrec(fid, LOTCALCCNT, 0);
	fwrite(fid, 0, 'uchar');

	% Lotus WK1 calcmode
	wk1wrec(fid, LOTCALCMOD, 0);
	fwrite(fid, -1, 'char');

	%
	% Lotus WK1 calorder
	%
	wk1wrec(fid, LOTCALCORD, 0);
	fwrite(fid, 0, 'char');

	%
	% Lotus WK1 split
	%
	wk1wrec(fid, LOTSPLTWM, 0);
	fwrite(fid, 0, 'char');

	%
	% Lotus WK1 sync
	%
	wk1wrec(fid, LOTSPLTWS, 0);
	fwrite(fid, 0, 'char');

	%
	% Lotus WK1 cursor12
	%
	wk1wrec(fid, LOTCURSORW12, 0);
	fwrite(fid, 1, 'char');

	%
	% Lotus WK1 window1, for now but needs work !!!
	%
	deffmt = 113;
	wk1wrec(fid, LOTWINDOW1, 0);
	fwrite(fid, [0 0], 'ushort');
	fwrite(fid, deffmt, 'char');	
	fwrite(fid, 0, 'char');	
	fwrite(fid, 10, 'ushort');
	fwrite(fid, [c r], 'ushort');
	fwrite(fid, [0 0 0 0], 'ushort');
	fwrite(fid, [0 0 0 0], 'ushort');
	fwrite(fid, [72 0], 'ushort');

	%
	% Lotus WK1 hidcol
	%
	x = [1:LOTHIDCOL(2)];
	buf = ones(size(x)) * 0;
	wk1wrec(fid, LOTHIDCOL, 0);
	fwrite(fid, buf, 'char');

	%
	% Lotus WK1 margins
	%
	buf = [4 76 66 2 2];
	wk1wrec(fid, LOTMARGINS, 0);
	fwrite(fid, buf, 'ushort');
	
	%
	% Lotus WK1 labelfmt
	%
	wk1wrec(fid, LOTLABELFMT, 0);
	fwrite(fid, '''', 'char');
	
	%
	% start dumping the array, for now number format float
	%
	for i = 1:r
		for j = 1:c
		wk1wrec(fid, LOTNUMBER, 0);
		fwrite(fid, deffmt, 'char');	
		fwrite(fid, [ j-1 i-1 ], 'ushort');
		fwrite(fid, m(i,j), 'double');
		end
	end


	%
	% Lotus WK1 EOF
	%
	fwrite(fid, LOTEOFSTR,'uchar');

	% close files
	fclose(fid);
