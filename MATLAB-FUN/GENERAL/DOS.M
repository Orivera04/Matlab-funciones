%DOS	Execute DOS command
%	DOS('command'), for Windows systems, calls upon the DOS shell
%	to execute the given command.  This causes a DOS Window to open
%	and the program, command or batch file is run within that window.
%	When the process is done executing, the window is automatically
%	closed and control returns to the MATLAB Command Window.
%
%	The following trailing characters have special meaning:
%		'|' - Run the DOS command iconically.
%		'&' - Return immediately to MATLAB, do not wait for process
%		      to finish.
%
%	Examples:
%
%	    dos('edit')
%
%	opens the DOS 5.0 editor in a DOS Window.
%
%	    dos('edit file.m &')
%
%	opens the DOS 5.0 editor in a DOS Window, and returns control
%	immediately to MATLAB.
%
%	    dos('type file.txt | sort > file.srt |')
%
%	pipes file.txt through the sort command and creates an output
%	file, file.srt.  The only thing that is seen on the screen, 
%	however, is a DOS icon.
%
%	See also ! (exclamation point) under PUNCT.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
