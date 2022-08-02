%DBCLEAR Remove an M-file breakpoint set by the DBSTOP command.
%	The DBCLEAR command removes the breakpoint set by a corresponding
%	DBSTOP command.  There are six forms to this command.  They are:
%
%	DBCLEAR AT lineno IN Mfilename
%	DBCLEAR ALL IN Mfilename
%	DBCLEAR IN Mfilename
%	DBCLEAR ALL
%	DBCLEAR IF ERROR
%	DBCLEAR IF NANINF  or  DBCLEAR IF INFNAN
%
%	where lineno is a line number in M-file function Mfilename.
%
%	The AT, IN and IF keywords are optional.
%
%	The first form removes the breakpoint at line lineno in M-file
%	function Mfilename.  The second form removes all breakpoints in
%	Mfilename.  The third form removes the breakpoint set at the first
%	executable line in Mfilename. The fourth form removes all breakpoints
%	in all M-files.  The fifth form clears the DBSTOP IF ERROR statement,
%	if set.  If a run-time error occurs after this command, MATLAB
%	terminates the current operation and returns to the base workspace.
%	The sixth form clears the DBSTOP on infinities and NaNs.
%
%	See also DBSTEP, DBSTOP, DBCONT, DBTYPE, DBSTACK, DBUP, 
%	DBDOWN, DBSTATUS, and DBQUIT.

%	Steve Bangert, 6-25-91. Revised, 1-3-92.
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
