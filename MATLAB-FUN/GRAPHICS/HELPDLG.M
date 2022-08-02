function handle = helpdlg(HelpString,dlgname)
%HELPDLG Displays a help dialog box.
%       HANDLE = HELPDLG(HELPSTRING,DLGNAME) displays the 
%       message HelpString in a dialog box with title DLGNAME.  
%       If a Help dialog with that name is already on the screen, 
%       it is brought to the front.  Otherwise it is created.
%
%       See also: DIALOG

%	Author(s): A. Potvin, 5-1-92
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	$Revision: 1.3 $  $Date: 1994/01/25 15:57:18 $

if nargin==0,
   HelpString = 'This is the default help string.';
end
if nargin<2,
   dlgname = 'Help Dialog';
end

handle = dialog('Style','help','TextString',HelpString, ...
                'Name',dlgname);

% end helpdlg
