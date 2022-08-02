function click = questdlg(q,yes,no,cancel,default)
%QUESTDLG Creates a question dialog box.
%       CLICK = QUESTDLG(Q,YES,NO,CANCEL,DEFAULT) creates a question
%       dialog box which displays Q.  Up to three pushbuttons, 
%       with strings given by YES, NO, and CANCEL will appear
%       along with Q in the dialog.  The dialog will be destroyed
%       returning the string CLICK depending  on which button is
%       clicked.  DEFAULT is the default button number.

%	Author(s): A. Potvin, 5-20-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	$Revision: 1.3 $  $Date: 1994/01/25 15:57:26 $

if nargin<4,
   ButtonString = [yes '|' no];
else
   ButtonString = [yes '|' no '|' cancel];
end

click = dialog('Style','question','TextString',q, ...
                'Name','Question Dialog', ...
                'ButtonStrings',ButtonString);

% end questdlg
