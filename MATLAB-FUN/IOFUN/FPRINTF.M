%FPRINTF Write formatted data to file.
%	COUNT = FPRINTF(FID,FORMAT,A,...) formats the data in matrix A (and in
%	any additional matrix arguments), under control of the specified FORMAT
%	string, and writes it to the file associated with file identifier FID.
%	COUNT is an optional output argument that returns the number of bytes
%	successfully written.
%
%	FID is an integer file identifier obtained from FOPEN. It can also
%	be 1 for standard output (the screen) or 2 for standard error.
%	
%	FORMAT is a string containing C language conversion specifications.
%	Conversion specifications involve the character %, optional flags,
%	optional width and precision fields, optional subtype specifier, and
%	conversion characters d, i, o, u, x, X, f, e, E, g, G, c, and s.
%	See a C manual for complete details.
%
%	FPRINTF behaves like ANSI C with certain exceptions and extensions. 
%	These include:
%
%	1. If the MATLAB double doesn't convert exactly to the datatype
%	   associated with the conversion specifier then e format is used.
%	   You must explicitly convert non-integral MATLAB values to
%	   integral values if you plan to use an integral conversion
%	   specifier like d and get the expected ANSI C behavior.
%	2. The following non-standard subtype specifiers are supported for
%	   conversion characters o, u, x, and X.
%
%	   t	- The underlying C datatype is a float rather than an
%		  unsigned integer.
%	   b	- The underlying C datatype is a double rather than an
%		  unsigned integer.
%
%	   For example, to print out in hex a double value use a format like
%	   '%bx'.
%
%	FPRINTF also differs from its C language namesake in an important
%	respect - it is "vectorized" for the case when A is nonscalar. The
%	format string is recycled through the elements of A (columnwise) until
%	all the elements are used up. It is then recycled in a similar manner, 
%	without reinitializing, through any additional matrix arguments.
%	
%	For example, the statements
%
%	    x = 0:.1:1; y = [x; exp(x)];
%	    fid = fopen('exp.txt','w');
%	    fprintf(fid,'%6.2f  %12.8f\n',y);
%
%	create a text file containing a short table of the exponential function:
%
%	    0.00    1.00000000
%	    0.10    1.10517092
%	         ...
%	    1.00    2.71828183
%
%	See also FSCANF, SPRINTF, FWRITE, DIARY, SAVE.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
