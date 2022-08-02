%FOPEN	Open file.
%	FID = FOPEN('filename',permission) opens the specified file with
%	the specified permission. Permission is one of the strings:
%	
%	    'r'	    read
%	    'w'	    write (create if necessary)
%	    'a'	    append (create if necessary)
%	    'r+'    read and write (do not create)
%	    'w+'    truncate or create for read and write
%	    'a+'    read and append (create if necessary)
%	    'W'     write without automatic flushing
%	    'A'     append without automatic flushing
%	
%	By default, files are opened in binary mode. To open a text file,
%	add 't' to the permission string, for example 'rt' and 'wt+'. (On
%	Unix and Macintosh systems, text and binary files are the same so
%	this has no effect. But on PC and VMS systems this is critical.)
%
%	FID = FOPEN('filename') assumes a permission of 'r'.
%	
%	If the open is successful, FID gets a scalar MATLAB integer, the
%	file identifier, to be used as the first argument to other FileIO
%	routines. If the open was not successful, -1 is returned for FID.
%	
%	Three file identifiers are automatically available and need not be
%	opened.  They are fid=0 (standard input), fid=1 (standard output),
%	and fid=2 (standard error).
%	
%	[FID, MESSAGE] = FOPEN('filename',permission) returns a system 
%   	dependent error message if the open is not successful.
%	
%	FOPEN('all') returns a row vector, the file identifiers for all the
%	files currently opened by the user. (But not 0, 1, and 2.)
%	
%	[FILENAME,PERMISSION] = FOPEN(FID) returns the filename and 
%   	permission associated with the given file identifier.
%
%	If the file is opened in 'r' mode and it is not found in the current
%	working directory, FOPEN searches down MATLAB's search path.
%
%	[FID, MESSAGE] = FOPEN('filename',permission, machineformat) opens the
%	specified file with the specified permission and treats data read
%	using FREAD or data written using FWRITE as having a format given
%	by machineformat. machineformat is one of the following strings:
%
%	'native'      or 'n' - local machine format - the default
%	'ieee-le'     or 'l' - IEEE floating point with little-endian
%	                       byte ordering
%	'ieee-be'     or 'b' - IEEE floating point with big-endian
%                              byte ordering
%	'vaxd'        or 'd' - VAX D floating point and VAX ordering
%	'vaxg'        or 'g' - VAX G floating point and VAX ordering
%	'cray'	      or 'c' - Cray floating point with big-endian
%	                       byte ordering
%	'ieee-le.l64' or 'a' - IEEE floating point with little-endian
%	                       byte ordering and 64 bit long data type
%	                       (currently supported on: alpha, sgi, ibm_rs,
%	                        hp300, vax, and cray platforms only)
%	
%	[FILENAME,PERMISSION,MACHINEFORMAT] = FOPEN(FID) returns the filename,
%	permission, and machineformat associated with the given file
%	identifier.
%
%       The 'W' and 'A' permissions are designed for use with tape drives and
%	do not automatically perform a flush of the current output buffer
%	after output operations. For example, open a 1/4" cartridge tape on a
%	SPARCstation for writing with no auto-flush:
%
%               fid = fopen('/dev/rst0','W')
%	
%	See also FCLOSE, FREWIND, FREAD, FWRITE, FPRINTF.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
