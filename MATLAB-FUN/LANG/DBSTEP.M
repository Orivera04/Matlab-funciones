%DBSTEP	Execute one or more MATLAB lines of code when in MATLAB debug mode.
%	The DBSTEP command allows the user to execute one or more lines of
%	executable MATLAB code and upon their completion revert back to the
%	debug mode.  There are three forms to this command.  They are:
%
%	DBSTEP
%	DBSTEP nlines
%	DBSTEP IN
%
%	where nlines is the number of executable lines to step.
%	The first form causes the execution of the next executable line.
%	The second form causes the execution of the next nlines executable
%	lines.  When the next executable line is a call to another M-file
%	function, the third form allows the user to step to the first 
%       executable line in the called M-file function.
%
%	See also DBCONT, DBSTOP, DBCLEAR, DBTYPE, DBSTACK, DBUP, DBDOWN,
%	and DBSTATUS.

%	Steve Bangert, 6-25-91.
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
