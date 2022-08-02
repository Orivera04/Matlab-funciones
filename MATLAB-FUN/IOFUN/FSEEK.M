%FSEEK	Change the position indicator in a file.
%	STATUS = FSEEK(FID, OFFSET, ORIGIN) repositions the file position
%	indicator in the specified file to the specified byte offset with
%	respect to the specified origin. 
%
%	FID is an integer file identifier obtained from FOPEN.
%
%	OFFSET values are interpreted as follows:
%	    > 0    Move toward the end of the file.
%	    = 0    Do not change position.
%	    < 0    Move toward the beginning of the file.
%
%	ORIGIN values are interpreted as follows:
%	    'bof' or -1   Beginning of file
%	    'cof' or  0   Current position in file
%	    'eof' or  1   End of file
%
%	STATUS is 0 on success and -1 on failure.
%
%	Example:
%
%	    fseek(fid,0,-1)
%
%	"rewinds" the file.
%
%	See also FOPEN, FTELL.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
