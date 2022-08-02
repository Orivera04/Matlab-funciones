function [P,F] = mbcinitprefs(P,F);
%MBCINITPREFS
%
%  MBCINITPREFS intialises the MBC preferences

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.8.4.4 $  $Date: 2004/04/04 03:25:48 $


% Check to see if there is a global flag that will inhibit dialogs
Gvars = who('global');
if any(strcmp(Gvars,'MBC_INIT_DIALOGS'))
   global MBC_INIT_DIALOGS
else
   MBC_INIT_DIALOGS = true;
end

% initialise units setting
idx = strmatch('UnitsDB', P.names, 'exact');
P.data{idx} = fullfile(xregrespath,'mbcunit.xml');

% initialise user information
idx = strmatch('UserInfo', P.names, 'exact');
infoS = P.data{idx};
infoS.Name = 'Unknown';
if MBC_INIT_DIALOGS
   P.data{idx} = i_getuserinfo(infoS);
else
   P.data{idx} = infoS;
end
return



function S=i_getuserinfo(S)
% display a dialog for user to input their details.  This is saved
% and used in project files etc as tracking information

scr=get(0,'screensize');
fH=xregdialog('name','User Information',...
   'tag','UserInformation',...
   'resize','off',...
   'position',[scr(3)/2-175 scr(4)/2-100 350 200]);

str = ['The following pieces of information may be included with files saved by',...
      ' the Model-Based Calibration Toolbox, in order to aid traceability.',...
      sprintf('\n') 'No information will be sent from your computer.'];
infobg = uicontrol('parent',fH,...
   'style','text',...
   'backgroundcolor','w');
infotxt = uicontrol('parent',fH,...
   'style','text',...
   'string',str,...
   'horizontalalignment','left',...
   'backgroundcolor','w');
div = xregGui.dividerline('parent',fH);
usereditorH = mbcfoundation.userinfoeditor('parent',fH,...
   'Labels',{'Name:','Company:','Department:','Contact Information:'},...
   'UserInfo',S);
okH = uicontrol('parent',fH,...
   'style','pushbutton',...
   'string','OK',...
   'callback','set(gcbf,''visible'',''off'',''userdata'',''ok'');');
cancelH = uicontrol('parent',fH,...
   'style','pushbutton',...
   'string','Cancel',...
   'callback','set(gcbf,''visible'',''off'');');

topinnerlyt = xreglayerlayout(fH,'packstatus','off',...
   'border',[5 5 5 5],...
   'elements',{infotxt});
toplyt=xreglayerlayout(fH,'elements',{infobg,topinnerlyt});

lyt = xreggridbaglayout(fH,'dimension',[6 5],...
   'packstatus','off',...
   'rowsizes',[55 2 10 -1 10 25],...
   'colsizes',[0 -1 65 65 0],...
   'gapx',7,...
   'border',[0 7 0 0],...
   'mergeblock',{[1 1],[1 5]},...
   'mergeblock',{[2 2],[1 5]},...
   'mergeblock',{[4 4],[2 4]},...
   'elements',{toplyt,div,[],[],[],[],...
      [],[],[],usereditorH,[],[],...
      [],[],[],[],[],okH,...
      [],[],[],[],[],cancelH});
fH.LayoutManager=lyt;
set(lyt,'packstatus','on');

fH.showDialog(okH);

okstat = get(fH,'userdata');
if strcmp(okstat,'ok')
   S = usereditorH.UserInfo;
end

delete(fH);drawnow;