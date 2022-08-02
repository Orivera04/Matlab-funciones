function m = csvread(filename, r, c, rng)
%CSVREAD Reads a Comma Separated Value file into a matrix.
% 	M = CSVREAD(filename, r, c, rng) reads Comma Separated Value formatted
%	file and returns the matrix M, optionally starting at offset r,c.
%   The comma is used as the delimiter within the file. 
%	rng is used to import only a specific a range.
%

%	Brian M. Bourgault 10/22/93
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%

	%
	% test for proper filename
	%
	if ~isstr(filename)
		error('csvread: Filename must be a string argument!');
		return
	end

	%
	% Call dlmread with a comma as the delimiter
	%
	if ~exist('r')
		r = 0;
	end
	if ~exist('c')
		c = 0;
	end
	if ~exist('rng')
		m=dlmread(filename, ',', r, c);
	else
		m=dlmread(filename, ',', r, c, rng);
	end
