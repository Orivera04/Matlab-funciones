%LOOKFOR Keyword search through the HELP entries.
%	LOOKFOR XYZ looks for the string XYZ in the first comment line
%	(the H1 line) of the HELP text in all M-files found on MATLABPATH.
%	For all files in which a match occurs, LOOKFOR displays the H1 line.
%
%	For example, "lookfor inverse" finds at least a dozen matches,
%	including the H1 lines containing "inverse hyperbolic cosine"
%	"two-dimensional inverse FFT", and "pseudoinverse".
%	Contrast this with "which inverse" or "what inverse", which run
%	more quickly, but which probably fail to find anything because
%	MATLAB does not ordinarily have a function "inverse".
%
%	LOOKFOR XYZ -all  searches the entire first comment block of
%	each M-file.
%
%	In summary, WHAT lists the functions in a given directory,
%	WHICH finds the directory containing a given function, and
%	LOOKFOR finds all functions in all directories that might have
%	something to do with a given key word.
%
%	See also DIR, HELP, WHO, WHAT, WHICH.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
