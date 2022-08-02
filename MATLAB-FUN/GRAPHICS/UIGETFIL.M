%UIGETFILE Interactively retrieve a filename by displaying a dialog box.
%	[FILENAME, PATHNAME] = UIGETFILE('filterSpec', 'dialogTitle', X, Y)
%	displays a dialog box for the user to fill in, and returns the
%	filename and path strings.  A successful return occurs only if
%	the file exists.  If the user selects a file that does not exist,
%	an error message is displayed, and control returns to the dialog box.
%	The user may then enter another filename, or press the Cancel button. 
%
%	All parameters are optional, but if one is used, all previous 
%	parameters must also be used.
%
%	The filterSpec parameter determines the initial display of files in 
%	the dialog box.  For example '*.m' lists all the MATLAB M-files.
%
%	Parameter 'dialogTitle' is a string containing the title of the dialog
%	box.
%
%	The X and Y parameters define the initial position of the dialog
%	box in units of pixels.  Some systems may not support this option.
%
%	The output variable FILENAME is a string containing the name of the 
%	file selected in the dialog box.  If the user presses the Cancel button
%	or if any error occurs, it is set to 0.
%
%	The output parameter PATHNAME is a string containing the path of
%	the file selected in the dialog box.  If the user presses the Cancel
%	button or if any error occurs, it is set to 0.
% 
%	See also UIPUTFILE.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.

