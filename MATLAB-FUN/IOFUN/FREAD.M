%FREAD	Read binary data from file.
%	[A, COUNT] = FREAD(FID,SIZE,PRECISION) reads binary data from the
%	specified file and writes it into matrix A.  Optional output
%	argument COUNT returns the number of elements successfully read. 
%	
%	FID is an integer file identifier obtained from FOPEN.
%	
%	The size argument is optional; if not specified, the entire
%	file is read; if specified, valid entries are:
%	    N      read N elements into a column vector.
%	    inf    read to the end of the file.
%	    [M,N]  read elements to fill an M-by-N matrix, in column order.
%		   N can be inf, but not M.
%	
%	The precision argument controls the number of bits read for each value
%	and the interpretation of those bits as character, integer or floating
%	point values.  Any of the following strings, either the MATLAB
%	versions, or their C or Fortran equivalents, may be used.  If not
%	specified, the default is 'uchar'.  The resulting matrix elements
%	are always stored as long floating point values, as is always the
%	case in MATLAB.
%	
%	    MATLAB    C or Fortran      Description
%	    'char'    'char'            character,  8 bits
%	    'schar'   'signed char'     signed character,  8 bits
%	    'short'   'short'           integer,  16 bits
%	    'int'     'int'             integer,  16 or 32 bits
%	    'long'    'long'            integer,  32 or 64 bits*
%	    'float'   'float'           floating point,  32 bits
%	    'double'  'double'          long floating point,  64 bits
%	    'uchar'   'unsigned char'   unsigned character,  8 bits
%	    'ushort'  'unsigned short'  unsigned integer,  16 bits
%	    'uint'    'unsigned int'    unsigned integer,  16 or 32 bits
%	    'ulong'   'unsigned long'   unsigned integer,  32 bits
%	
%	    'char'    'char*1'          character,  8 bits
%	    'float32' 'real*4'          32 bit floating point
%	    'float64' 'real*8'          64 bit floating point
%	    'int8'    'integer*1'       integer, 8 bits.
%	    'int16'   'integer*2'       integer, 16 bits.
%	    'int32'   'integer*4'       integer, 32 bits.
%	              'integer*8'       integer, 64 bits.**
%	     'intN'                     signed integer, N bits wide
%	     'uintN'                    unsigned integer, N bits wide
%	
%	     N represents any value between 1 and 32.
%	     * 64 bits on DEC alpha
%	     ** available on DEC alpha only
%
%	For example,
%	    fid = fopen('fread.m','r');
%	    F = fread(fid);
%	    s = setstr(F')
%
%	opens the file containing this HELP entry, then reads and displays
%	the entire file, using default size = inf and precision = 'uchar'.
%	The resulting length(F) is the number of characters in the file.
%
%	[A, COUNT] = FREAD(FID,SIZE,PRECISION,SKIP) includes an optional SKIP
%	argument that specifies the number of bytes to skip after each read.
%	This is useful for extracting data in noncontiguous fields from fixed
%	length records.
%
%	See also FWRITE, FSCANF, LOAD.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.

%
%	NOTE: The only supported precisions for Cray data are
%	      'char', 'schar', 'uchar', 'float', 'double', and 'float64'.
