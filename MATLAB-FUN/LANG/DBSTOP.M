%DBSTOP	Set breakpoint in MATLAB M-file function.
%	The DBSTOP command is used to temporarily stop the execution of an
%	M-file function and give the user an opportunity to examine the local
%	workspace.  Issuing a DBSTOP command is equivalent to editing the
%	M-file function and inserting a KEYBOARD command in front of the line
%	number specified.  There are four forms to this command.  They are:
%
%	DBSTOP AT lineno IN Mfilename
%	DBSTOP IN Mfilename
%	DBSTOP IF ERROR
%	DBSTOP IF NANINF  or  DBSTOP IF INFNAN
%
%	where lineno is a line number within M-file function Mfilename.
%
%	The AT, IN and IF keywords are optional.
%
%	The first form stops at the specified line number in the M-file.
%	The second form stops at the first executable line in the M-file.
%	The third form causes a stop in any M-file function causing a
%	run-time error.  (Syntax errors are not handled by the debugger.)
%	You cannot resume M-file execution after a run-time error.
%	The fourth form causes a stop in any M-file function where an
%	an infinite value (Inf) or Not-a-Number (NaN) is detected.
%	The DBSTOP command is the only way to enter MATLAB's debug mode.
%	In MATLAB's debug mode, any MATLAB command is allowed at the prompt.
%
%	See also DBCONT, DBSTEP, DBCLEAR, DBTYPE, DBSTACK, DBUP, DBDOWN,
%	DBSTATUS, and DBQUIT.

%	Steve Bangert, 6-25-91. Revised, 1-3-92.
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
