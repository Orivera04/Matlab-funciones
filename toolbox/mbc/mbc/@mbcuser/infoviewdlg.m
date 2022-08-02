function H = infoviewdlg( obj ,varargin)
%INFOVIEWDLG Create a dialog for viewing user information
%
%   INFOVIEWDLG(OBJ) creates a modal dialog and does not return until
%   it is closed.
%   H=INFOVIEWDLG(OBJ,'non-modal')  creates a non-modal dialog and 
%   returns its figure handle.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.4.3 $  $Date: 2004/02/09 06:45:40 $


modal = true;
if nargin>1
   if strcmp(varargin{1},'non-modal')
      modal = false;
   end
end

scr=get(0,'screensize');
if modal
   H = xregdialog('tag','UserInfoViewer',...
      'Name','User Information',...
      'Resize','off',...
      'position',[scr(3)/2-150 scr(4)/2-50 300 100]);
   xregpersistfigpos(H);
   xregmoveonscreen(H);
else
   H = xregfigure('tag','UserInfoViewer',...
      'Name','User Information',...
      'visible','off',...
      'Resize','off',...
      'position',[scr(3)/2-150 scr(4)/2-50 300 100]);
   xregpersistfigpos(H);
   xregmoveonscreen(H);
end
infolyt = createguiobject(obj,'view',H);
lyt = xreglayerlayout(H,...
   'elements',{infolyt},...
   'packstatus','off',...
   'border',[10 10 10 10]);
H.LayoutManager = lyt;
set(lyt,'packstatus','on');

if modal
    H.showDialog;
    delete(H);
    H=[];
else
    H.Visible = 'on';
end