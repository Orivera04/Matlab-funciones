function showerrordialog(obj, msg, title, headmsg)
%SHOWERRORDIALOG Show a formula error dialog
%
%  OBJ = SHOWERRORDIALOG(OBJ, MSG, TITLE, HEADMSG) displays an error dialog
%  suitable for use when a formula fails its checks.  MSG is a cell array
%  of strings that will be prefixed with a bullet.  TITLE is the title of
%  the dialog.  HEADMSG is an optional string to place above the bulleted
%  list;  the default action will be to place the string 'This formula
%  cannot be accepted for the following reasons:' above the bullets.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 07:16:03 $ 

if nargin<4
    headmsg = 'This formula cannot be accepted for the following reasons:';
else
    headmsg = detex(headmsg);
end
mode = struct('WindowStyle', 'modal', 'Interpreter', 'tex');

for n = 1:length(msg)
    msg{n} = ['\bullet  ' detex(msg{n})];
end
msg = [{headmsg};{''}; msg];
h = errordlg(msg,title, mode);
waitfor(h);