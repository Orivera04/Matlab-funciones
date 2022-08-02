%FERROR	Query errors in file input or output.
%	MESSAGE = FERROR(FID,'clear') returns the error message for the
%	most recent file I/O operation associated with the specified file. 
%	The string 'clear' is optional.  If present, it clears the error
%	indicator for the specified file.
%
%	[MESSAGE, ERRNUM] = FERROR(FID) also returns the error number.
%
%	FID is an integer file identifier obtained from FOPEN, or 0 for
%	standard input, 1 for standard output or 2 for standard error.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
