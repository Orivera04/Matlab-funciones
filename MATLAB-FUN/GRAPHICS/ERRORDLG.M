function handle = errordlg(errorstr,dlgname,Replace)
%ERRORDLG Creates an error dialog box.
%       HANDLE = ERRORDLG(ERRORSTR,DLGNAME,Replace) creates an 
%       error dialog box which displays ERRORSTR in a window 
%       named DLGNAME.  A pushbutton labeled OK must be pressed 
%       to make the error box disappear.  If REPLACE='on' and 
%       an error dialog with Name DLGMANE already exits, it is
%       simply brought to the front (no new dialog is created).
%
%       See also: DIALOG

%	Author(s): A. Potvin, 5-1-92
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	$Revision: 1.3 $  $Date: 1994/01/25 15:57:13 $

ni = nargin;
if ni==0,
   errorstr = 'This is the default error string.';
end
if ni<2,
   dlgname = 'Error Dialog';
end
if ni<3,
   Replace = 'off';
end

handle = dialog('Style','error','TextString',errorstr, ...
                'Name',dlgname,'Replace',Replace);

% end errordlg
