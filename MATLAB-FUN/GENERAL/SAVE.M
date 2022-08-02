%SAVE	Save workspace variables on disk.
% 	SAVE fname saves all workspace variables to the binary "MAT-file"
%   	named fname.mat. The data may be retrieved with LOAD. Omitting the
%   	filename causes SAVE to use the default filename "matlab.mat".
%
% 	SAVE fname X  saves only X.
% 	SAVE fname X Y Z  saves X, Y, and Z.
%
% 	SAVE fname X Y Z  -ascii  uses 8-digit ASCII form instead of binary.
% 	SAVE fname X Y Z  -ascii -double  uses 16-digit ASCII form.
% 	SAVE fname X Y Z  -ascii -double -tabs  delimits with tabs.
%
%   	If fname is "stdio", SAVE sends the data to standard output.
%
%	The binary formats used in MAT-files depend upon the size and type of
%	each matrix.  Small matrices and matrices with any noninteger entries
%	are saved in floating point format requiring 8 bytes per real element.  
%	Large, integer matrices may be saved in compact formats requiring
%	only 1, 2 or 4 bytes per element.  See the External Interface Library
%	for more details, including C and Fortran routines to read and write
%	MAT-files from external programs.
%
% 	See also LOAD, DIARY, FWRITE, FPRINTF, IMWRITE.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
