%HELP	On-line documentation. 
%	HELP, by itself, lists all primary help topics.  Each primary topic
%	corresponds to a directory name on MATLABPATH.
%
%	"HELP topic" gives help on the specified topic.  The topic can be
%	a command name or a directory name.  If it is a command name, HELP
%	displays information on that command.  If it is a directory name, 
%	HELP displays the Table-Of-Contents for the specified directory.
%	It is not necessary to give the full pathname of the directory; 
%	the last component, or last several components, are sufficient.
%
%	For example, "help general" and "help matlab/general" both list
%	the Table-Of-Contents for the directory toolbox/matlab/general.
%
%	LOOKFOR XYZ looks for the string XYZ in the first comment line
%	of the HELP text in all M-files found on MATLABPATH.  For all files
%	in which a match occurs, LOOKFOR displays the matching lines.
%
%	MORE ON causes HELP to pause between screenfuls if the help text
%	runs to several screens.
%
%	See also LOOKFOR, WHAT, WHICH, DIR, MORE.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
