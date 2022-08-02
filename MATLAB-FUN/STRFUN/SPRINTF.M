%SPRINTF Write formatted data to a string.
%	[S,ERRMSG] = SPRINTF(FORMAT,A,...) formats the data in matrix A
%	(and in any additional matrix arguments), under control of the
%	specified FORMAT string, and returns it in the MATLAB string variable
%	S. ERRMSG is an optional output argument that returns an error
%	message string if an error occurred or an empty matrix if an error
%	did not occur.
%
%	SPRINTF is the same as FPRINTF except that it returns the data in
%	a MATLAB string variable rather than writing it to a file.
%
%       FORMAT is a string containing C language conversion specifications.
%       Conversion specifications involve the character %, optional flags,
%       optional width and precision fields, optional subtype specifier, and
%       conversion characters d, i, o, u, x, X, f, e, E, g, G, c, and s.
%       See a C manual for complete details.
%
%       SPRINTF behaves like ANSI C with certain exceptions and extensions.
%       These include:
%
%       1. If the MATLAB double doesn't convert exactly to the datatype
%          associated with the conversion specifier then e format is used.
%          You must explicitly convert non-integral MATLAB values to
%          integral values if you plan to use an integral conversion
%          specifier like d and get the expected ANSI C behavior.
%       2. The following non-standard subtype specifiers are supported for
%          conversion characters o, u, x, and X.
%
%          t    - The underlying C datatype is a float rather than an
%                 unsigned integer.
%          b    - The underlying C datatype is a double rather than an
%                 unsigned integer.
%
%          For example, to print out in hex a double value use a format like
%          '%bx'.
%
%	SPRINTF differs from its C language namesake in an important
%	respect - it is "vectorized" for the case when A is nonscalar. The
%	format string is recycled through the elements of A (columnwise) until
%	all the elements are used up. It is then recycled in a similar manner, 
%	without reinitializing, through any additional matrix arguments.
%
%	For example, the statement
%
%	    S = sprintf('rho is %5.3f',(1+sqrt(5))/2)
%
%	produces the string
%
%	    S = 'rho is 1.618'
%
%	See also FPRINTF, SSCANF, FWRITE, NUM2STR, INT2STR.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
