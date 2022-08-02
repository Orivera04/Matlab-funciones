function msg = nargchk(low,high,number)
%NARGCHK  Check number of input arguments. 
%	Return error message if	not between low and high.  
%	If it is, return empty matrix.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

msg = [];
if (number < low)
	msg = 'Not enough input arguments.';
elseif (number > high)
	msg = 'Too many input arguments.';
end
