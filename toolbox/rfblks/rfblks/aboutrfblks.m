function aboutrfblks
%ABOUTRFBLKS Displays version number of the RF Blockset and 
%             and the copyright notice in a modal dialog box.

%   Copyright 2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/03/05 18:23:36 $
 
str = sprintf(['RF Blockset 1.0\n',...
	'Copyright 2004 The MathWorks, Inc.']);
msgbox(str,'About the RF Blockset','modal');

% [EOF] aboutrfblks.m
