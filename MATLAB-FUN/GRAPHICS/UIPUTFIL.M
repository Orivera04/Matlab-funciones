%UIPUTFILE Interactively retrieve a filename by displaying a dialog box.
%	[FILENAME, PATHNAME] = UIPUTFILE('initFile', 'dialogTitle')
%	displays a dialog box and returns the filename and path strings.
%
%	The initFile parameter determines the initial display of files 
%	in the dialog box.  Full file name specifications as well as wildcards
%	are allowed.  For example, 'newfile.m' initializes the display to
%	that particular file and lists all other existing.m files.  This may
%	be used to provide a default file name.  A wildcard specification such
%	as '*.m' lists all the existing MATLAB M-files.
%
%	Parameter 'dialogTitle' is a string containing the title of the dialog
%	box.
%
%	The output variable FILENAME is a string containing the name of the
%	file selected in the dialog box.  If the user presses the Cancel button
%	or if any error occurs, it is set to 0.
%
%	The output variable PATH is a string containing the name of the path
%	selected in the dialog box.  If the user presses the Cancel button 
%	or if any error occurs, it is set to 0.
%
%	[FILENAME, PATHNAME] = UIPUTFILE('initFile', 'dialogTitle',X,Y)
%	places the dialog box at screen position [X,Y] in pixel units.
%	Not all systems support this option.
%
%	Example:
%		[newmatfile, newpath] = uiputfile('*.mat', 'Save As');
% 
%	See also UIGETFILE.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.

