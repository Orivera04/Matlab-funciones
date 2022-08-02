%LOAD	Retrieve variables from disk.
%	LOAD fname  retrieves the variables from the MAT-file 'fname.mat'.
%	LOAD, by itself, loads from the file named 'matlab.mat'.
%	LOAD xxx.yyy  reads the ASCII file xxx.yyy, which must contain a
%	rectangular array of numeric data, arranged in m lines with n values
%	in each line.  The result is an m-by-n matrix named xxx.
%
%	To load an ASCII file that does not have a filename extension, use
%	LOAD fname -ascii. Otherwise MATLAB adds the extension '.mat' and
%	tries to load it as a MAT-file. To load a MAT-file that does NOT
%	have a '.mat' extension, use LOAD fname.ext -mat.
%
%   	If fname is "stdio", LOAD reads from standard input.
%
% 	See also SAVE, SPCONVERT, FSCANF, FPRINTF.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
