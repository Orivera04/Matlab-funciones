%UISETCOLOR Interactively set a ColorSpec by displaying a dialog box.
%	C = UISETCOLOR(ARG, 'dialogTitle') displays a dialog box for the 
%	user to fill in, and applies the selected color to the input 
%	graphics object.
%
%	The parameters are optional and may be specified in any order.
%
%	ARG may be either a handle to a graphics object or an RGB triple.
%	If a handle is used, it must specify a graphics object that supports 
%	color.  If RGB is used, it must be a valid RGB triple (e.g., [1 0 0] 
%	for red).  In both cases, the color specified is used to initialize
%	the dialog box.  If no initial RGB is specified, the dialog box
%	initializes the color to black.
%
%	If parameter 'dialogTitle' is used, it is a string containing the 
%	title of the dialog box.
%
%	The output value C is the selected RGB triple.  If the input parameter
%	is a handle, the graphics object's color is set to the RGB color 
%	selected.
%
%	If the user presses Cancel from the dialog box, or if any error 
%	occurs, the output value is set to the input RGB triple, if provided; 
%	otherwise, it is set to 0.
%
%	Example:
%		C = uisetcolor(hText, 'Set Text Color')
%
%	NOTE: This function is only available in MS-Windows and Macintosh
%		versions of MATLAB.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.

