%FTELL	Location of the position indicator in a file.
%	POSITION = FTELL(FID) returns the location of the file position
%	indicator in the specified file.  Position is indicated in bytes
%	from the beginning of the file.  If -1 is returned, it indicates
%	that the query was unsuccessful; use FERROR to determine the nature
%	of the error.
%
%	FID is an integer file identifier obtained from FOPEN, or 0 for
%	standard input, 1 for standard output or 2 for standard error.
%
%	See also FOPEN, FSEEK.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
