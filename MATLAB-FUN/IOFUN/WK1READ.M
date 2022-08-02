function m=wk1read(filename, r, c, rng)
%WK1READ Read a Lotus123 WK1 file into a matrix.
% 	M=WK1READ(filename, r, c, rng) reads Lotus WK1 spreadsheet file 
%	and returns the matrix M, optionally starting at offset r,c.
%	rng is used to import only a spreadsheet's range or named range.
%

%	Brian M. Bourgault 10/22/93
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%
% $Revision: 1.7 $
%
	%
	% include WK1 constants
	%
	wk1const

	%
	% test for proper filename
	%
	if ~isstr(filename)
		error('wk1read: Filename must be a string argument!');
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
	if ~exist('rng')
		% max range of cells for WK1 format
		rng = [1 1 256 8192];
	end
	%
	% get the upper-left and bottom-rignt cells
	% of the range to read into MATLAB
	%
	if ~isstr(rng)
		% user gave us a range, in matlab form, to import [1 1 3 5]
		ulc = rng(1:2);
		brc = rng(3:4);
	else
		x = str2rng(rng);
		if(x ~= [])
			% user gave us a cell range to import 'A1..C5'
			ulc = x(1:2);
			brc = x(3:4);
		% else
		% user gave us a named range to import 'SALES'
		% for now assume case sensitive
		% rng = upper(rng);
		end
	end

	%
	% open the file Lotus uses Little Endian Format ONLY
	%
	fid = fopen([filename '.wk1'],'rb', 'l');
	if fid == (-1)
		error(['wk1read: Could not open file ' filename '.wk1']);
	end

	%
	% Read Lotus WK1 BOF
	%
	header = fread(fid, 6,'uchar');
	if(header(1) ~= LOTWK1BOFSTR)
		error('wk1read: Not a valid WK1 file !');
	end

	%
	% Start processing WK1 Records
	% Read WK1 record header
	% cell = [col row]
	% Note: Convert Lotus 0 based to 1 based cell coordinates 
	%
	rec = fread(fid, 2, 'ushort');
	while(rec(1) ~= LOTEND(1))
		if(rec(1) == LOTNUMBER(1))
			%
			% 8 byte double
			%
			fmt  = fread(fid, 1,'uchar');
			cell = fread(fid, 2,'ushort');
			cell = cell' + 1;
			val  = fread(fid, 1,'double');
			if((cell >= ulc) & (cell <= brc))
				m(cell(2)+r,cell(1)+c) = val(1);
			end
		else
			if(rec(1) == LOTINTEGER(1))
				%
				% 2 byte integer
				%
				fmt  = fread(fid, 1,'uchar');
				cell = fread(fid, 2,'ushort');
				val  = fread(fid, 1,'short');
				cell = cell' + 1;
				if((cell >= ulc) & (cell <= brc))
					m(cell(2)+r,cell(1)+c) = val(1);
				end
			else
				if(rec(1) == LOTFORMULA(1))
					%
					% 8 byte double from a Formula
					%
					fmt  = fread(fid, 1,'uchar');
					cell = fread(fid, 2,'ushort');
					cell = cell' + 1;
					val  = fread(fid, 1,'double');
					if((cell >= ulc) & (cell <= brc))
						m(cell(2)+r,cell(1)+c) = val(1);
					end
					fread(fid, rec(2)-13,'uchar');
				else
					if(rec(1) == LOTNRANGE(1) & isstr(rng))
						%
						% Named Range
						%
						if isstr(rng) 
							n = fread(fid, 16,'char');
%							n = upper(setstr(n'));
							n = setstr(n');
							n = deblank(n);
							nrng = fread(fid, 4,'ushort');
							nrng = nrng';
							% need to pad n with zeros, this is a bug in strcmp
%							rng = upper(setstr(rng));
							rng = setstr(rng);
							rng = deblank(rng);
							if strcmp(rng,n)
								% found the named range the user wants
								ulc = nrng(1:2) + 1;
								brc = nrng(3:4) + 1;
								% bring ulc of named ranged to ulc of matrix
								c = c - nrng(1);
								r = r - nrng(2);
							end
						end
					else
						%
						% read past this record
						%
						fread(fid, rec(2),'uchar');
					end
				end
			end
		end
		%
		% get the next WK1 record header
		%
		rec = fread(fid, 2, 'ushort');
	end

% close file
fclose(fid);
