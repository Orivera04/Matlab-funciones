%UNIX	Execute UNIX operating system command.
%	[status,result] = UNIX('command'), for UNIX systems, calls upon
%	the operating system to execute the given command.  The resulting
%	status and standard output are returned.
%
%	Examples:
%
%	    [s,w] = unix('who')
%
%	returns s = 0 and, in w, a MATLAB string containing a list of
%	the users currently logged in.
%
%	    [s,w] = unix('why')
%
%	returns a nonzero value in s to indicate failure and sets w to
%	the null matrix because "why" is not a UNIX command.
%
%	    [s,m] = unix('matlab')
%
%	never returns because running the second copy of MATLAB requires
%	interactive user input which cannot be provided.
%
%	See also ! (exclamation point) under PUNCT.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
