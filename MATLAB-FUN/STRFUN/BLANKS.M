function b = blanks(n)
%BLANKS	A string of blanks.
%	BLANKS(n) is a string of n blanks.
%	Use with DISP, eg.  DISP(['xxx' BLANKS(20) 'yyy']).
%	DISP(BLANKS(n)') moves the cursor down n lines.
%
%	See also CLC, HOME, FORMAT COMPACT.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

b = setstr(ones(1,n)*' ');
