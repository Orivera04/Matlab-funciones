function handle = warndlg(warnstr,dlgname)
%WARNDLG Creates an warning dialog box.
%       HANDLE = WARNDLG(WARNSTR,DLGNAME) creates an warning 
%       dialog box which displays WARNSTR in a window named 
%       DLGNAME.  A pushbutton labeled OK must be pressed to 
%       make the warning box disappear.
%
%       See also: DIALOG

%	Author(s): A. Potvin, 5-1-92
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	$Revision: 1.3 $  $Date: 1994/01/25 15:57:35 $

if nargin==0,
   warnstr = 'This is the default warning string.';
end
if nargin<2,
   dlgname = 'Warning Dialog';
end

handle = dialog('Style','warning','TextString',warnstr, ...
                'Name',dlgname);

% end warndlg
