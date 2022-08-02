%LASTERR Last error message.
%	LASTERR, by itself, returns a string containing the last
%	error message issued by MATLAB.
%
%	LASTERR('') resets the LASTERR function so that it will
%	return an empty matrix until the next error is encountered.
%	
%	LASTERR is usually used in conjunction with the two 
%	argument form of EVAL: EVAL('try','catch').  The 'catch'
%	action can examine the LASTERR string to determine the
%	cause of the error and take appropriate action.
%
%	See also EVAL, ERROR.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
