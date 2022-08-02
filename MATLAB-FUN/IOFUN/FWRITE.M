%FWRITE	Write binary data to a file.
%	COUNT = FWRITE(FID,A,PRECISION) writes the elements of matrix A
%	to the specified file, translating MATLAB values to the specified
%	precision. The data are written in column order.  COUNT is the number
%	of elements successfully written. 
%
%	FID is an integer file identifier obtained from FOPEN, or 1 for
%	standard output or 2 for standard error.
%	
%	PRECISION controls the form and size of the result.  See the list
%	of allowed precisions under FREAD.
%
%	COUNT = FWRITE(FID,A,PRECISION,SKIP) includes an optional SKIP
%	argument that specifies the number of bytes to skip before each write.
%	This is useful for inserting data into noncontiguous fields in fixed
%	length records.
%
%	For example,
%
%	    fid = fopen('magic5.bin','wb')
%	    fwrite(fid,magic(5),'integer*4')
%
%	creates a 100-byte binary file, containing the 25 elements of the
%	5-by-5 magic square, stored as 4-byte integers.
%
%	See also FREAD, FPRINTF, SAVE, DIARY.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
