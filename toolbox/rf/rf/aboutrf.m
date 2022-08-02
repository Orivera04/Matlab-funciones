function aboutrf
%ABOUTRF Displays version number of the RF Toolbox and 
%             and the copyright notice in a modal dialog box.

%   Copyright 2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/03/05 18:22:17 $
 
str = sprintf(['RF Toolbox 1.0\n',...
	'Copyright 2004 The MathWorks, Inc.']);
msgbox(str,'About the RF Toolbox','modal');

% [EOF] aboutrf.m
