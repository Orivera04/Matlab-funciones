%UISETFONT Interactively set a font by displaying a dialog box.
%	H = UISETFONT(HIN, 'dialogTitle') displays a dialog box for the 
%	user to fill in, and applies the selected font to the input 
%	graphics object.
%
%	The parameters are optional and may be specified in any order.
%
%	If parameter HIN is used, it must specify a handle to a text or 
%	axis graphics object.  The font properties currently assigned to this
%	object are used to initialize the font dialog box.
%
%	If parameter 'dialogTitle' is used, it is a string containing the 
%	title of the dialog box.
%
%	The output H is is a handle to a graphics object.  If HIN is specified,
%	H is identical to HIN.  If HIN is not specified, a new text object
%	is created with the selected font properties, and its handle is
%	returned.
%
%	If the user presses Cancel from the dialog box, or if any error 
%	occurs, the output value is set to the input handle, if provided; 
%	otherwise, it is set to 0.
%
%	Example:
%		uisetfont(hText, 'Update Font')
%
%	NOTE: This function is only available in MS-Windows and Macintosh
%		versions of MATLAB.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.

