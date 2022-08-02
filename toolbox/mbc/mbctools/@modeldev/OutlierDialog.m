function [mdev,ok] = OutlierDialog(mdev)
%OUTLIERDIALOG Display the Outlier Selection Criteria dialog
%
%  [MDEV, OK] = OUTLIERDIALOG(MDEV) displays the Outlier Selection Criteria
%  dialog which allows users to select the criteria to use when
%  highlighting outliers.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.8.4.3 $  $Date: 2004/04/04 03:31:45 $

figh = xregdialog('name','Outlier Selection Criteria',...
   'renderer','zbuffer',...
   'position',[1 1 580 140],...
   'tag','ResponseModSetup',...
   'resize','off');
xregcenterfigure(figh);

p_md = address(mdev);
[lyt,ud] = i_createlyt(figh,p_md);

% ok and cancel buttons
okbtn = uicontrol('parent',figh,...
   'string','OK',...
   'style','pushbutton',...
   'callback','set(gcbf, ''tag'', ''ok'', ''visible'', ''off'');');
cancbtn = uicontrol('parent',figh,...
   'string','Cancel',...
   'style','pushbutton',...
   'callback','set(gcbf, ''tag'', ''cancel'', ''visible'', ''off'');');
helpbtn = mv_helpbutton(figh,'xreg_outlierCriteria');

mainlyt = xreggridbaglayout(figh, ...
    'dimension', [2 4], ...
    'rowsizes', [-1 25], ...
    'colsizes', [-1 65 65 65], ...
    'gapx', 7, ...
    'gapy', 7, ...
    'border', [7 7 7 10], ...
    'mergeblock', {[1 1], [1 4]}, ...
    'elements', {lyt, [], [], okbtn, [], cancbtn, [], helpbtn});

figh.LayoutManager = mainlyt;
set(mainlyt, 'packstatus', 'on');

% Blocking call
figh.showDialog(okbtn);

tg = get(figh,'tag');
switch lower(tg)
case 'ok'
   if get(ud.UserDefCheck,'value')
      str = get(ud.UserDef,'string');
      ok= exist(str)==2;
      crit= str;
   else
      % note that the "abs val" popup is 1 for yes (want 1) and 2 for no (want 0)
      % hence use mod 2 below
      crit=[get(ud.criteria,'value'),...        % the statistic
            mod(get(ud.absVal,'value'),2),...   % use abs val of data?
            get(ud.operator,'value'),...        % < or whatever
            get(ud.value,'value'),...           % numerical value
            get(ud.distribution,'value')];      % distribution to use
      ok= isnumeric(crit);
   end
   if ~ok 
      crit=[];
      ok=1;
   end
   
   
   if ok
      OldMdev= mdev;
      try
         m= model(mdev);
         set(m,'outliers',crit);
         mdev= model(mdev,m);
      catch
         mdev= OldMdev;
         pointer(OldMdev);
         ok= 0;
      end
   end
   ok=1;
otherwise 
   ok=0;
end
mdev= info(mdev);
delete(figh);



%-------------------------
%  SUBFUNCTION i_createlyt
%-------------------------
function [lyt,ud]=i_createlyt(figh,p)

mdev= info(p);
[data,factors]= diagnosticStats(mdev);
m= model(mdev);

SC = xregGui.SystemColorsDbl;

% reate all the controls
ud.seltxt=uicontrol('style','text',...
   'parent',figh,...
   'horizontalalignment','left',...
   'string','Select using:',...
   'position',[0 0 80 15]);
ud.criteria=uicontrol('style','popup',...
   'parent',figh,...
   'horizontalalignment','left',...
   'backGroundColor',SC.WINDOW_BG,...
   'userdata',data,...
   'string',factors);
ud.abstxt=uicontrol('style','text',...
   'parent',figh,...
   'horizontalalignment','left',...
   'string','Use absolute value?',...
   'position',[0 0 80 15]);
ud.absVal=uicontrol('style','popup',...
   'parent',figh,...
   'horizontalalignment','left',...
   'backGroundColor',SC.WINDOW_BG,...
   'string',{'Yes','No'});
ud.optxt=uicontrol('style','text',...
   'parent',figh,...
   'horizontalalignment','left',...
   'string','Operator:',...
   'position',[0 0 80 15]);
ud.operator=uicontrol('style','popup',...
   'parent',figh,...
   'horizontalalignment','left',...
   'backGroundColor',SC.WINDOW_BG,...
   'string',{'<','>','<=','>=','==','~='});
ud.distxt=uicontrol('style','text',...
   'parent',figh,...
   'horizontalalignment','left',...
   'string','Distribution:',...
   'position',[0 0 80 15]);
ud.distribution=uicontrol('style','popup',...
   'parent',figh,...
   'horizontalalignment','left',...
   'backGroundColor',SC.WINDOW_BG,...
   'string',{'None','Student''s t','Normal'});
ud.valtxt=uicontrol('style','text',...
   'parent',figh,...
   'horizontalalignment','left',...
   'string','Value:',...
   'position',[0 0 80 15]);
ud.value= xregGui.clickedit(figh,...
   'backgroundcolor', SC.WINDOW_BG, ...
   'dragging','on');

ud.UserDefCheck=uicontrol('style','check',...
   'parent',figh,...
   'horizontalalignment','left',...
   'string','Select using custom m-file:',...
   'position',[0 0 80 15]);
ud.UserDef=uicontrol('style','edit',...
   'parent',figh,...
   'enable','off',...
   'horizontalalignment','left',...
   'backgroundcolor',SC.CTRL_BG,...
   'position',[0 0 80 15]);
ud.chooseFile = uicontrol('parent', figh,...
	'style','pushbutton',...
    'enable','off',...
	'string','...');

lyt= xreggridbaglayout(figh,...
    'dimension',[4 7],...
    'mergeblock',{[1 1],[4 5]},... % dist text
    'mergeblock',{[2 2],[4 5]},... % dist popup
    'mergeblock',{[4 4],[2 4]},... % name of file edit box
    'mergeblock',{[1 1],[6 7]},... % value text
    'gapx',10,...
    'colsizes',[-1 100 50 50 20 80 20] ,...
    'rowsizes',[17,20,20,20], ...
    'elements',{...
    ud.seltxt,ud.criteria,[],ud.UserDefCheck,...
    ud.abstxt,ud.absVal,[],ud.UserDef,...
    ud.optxt,ud.operator,[],[],...
    ud.distxt,ud.distribution,[],[],...
    [],[],[],ud.chooseFile, ...
    ud.valtxt,ud.value,[],[]});

% define callbacks
set(ud.criteria,'callback',{@i_criteria,ud});
set(ud.absVal,'callback',{@i_absval,ud});
set(ud.UserDefCheck,'callback',{@i_userdef,ud});
set(ud.chooseFile,'callback',{@i_chooseFile,ud});
set(ud.distribution,'callback',{@i_criteria,ud});

% if we already have some criteria defined, display this in the controls
crit= get(m,'outliers');
if isempty(crit);
   crit= DefaultOutliers(m);
end

if isnumeric(crit)
    if size(crit,2)<5
        crit(:,5)=1;
    end
    if crit(1)<=length(get(ud.criteria,'string'))
        set(ud.criteria,'value',crit(1));
    end
    set(ud.distribution,'value',crit(5));
    
    % note that the "abs val" is 1 for yes (want 1) and 0 for no (want 2)
    % hence use 2-value below to set the popup
    set(ud.absVal,'value',2-crit(2));
    set(ud.operator,'value',crit(3));
    set(ud.value,'value',crit(4));
    
    i_criteria(ud.criteria,[],ud);
    
elseif ischar(crit)
    set(ud.UserDefCheck,'value',1);
    % do the enable/disable thing
    i_userdef(ud.UserDefCheck,[],ud);
    set(ud.UserDef,'string',crit);
end

%-------------------------
%  SUBFUNCTION i_criteria
%-------------------------
function i_criteria(src,event,ud)

SC = xregGui.SystemColorsDbl;

data= get(ud.criteria,'userdata'); % data is numpoints rows x num factors columns
critVal = get(ud.criteria,'value');
thisData = data(:,critVal);
% set the clickincrement to be appropriate for this factor

switch get(ud.distribution,'value')
case 1 % not using distribution
   if ~isempty(thisData)
      set(ud.value,'clickincrement',10^(floor(log10(range(thisData)))-1));
   else
       set(ud.value,'clickincrement',1);
   end
   if get(ud.absVal, 'value')==1 % absVal = Yes
       minval = 0;
   else
       minval = -inf;
   end
   set(ud.value, 'min', minval, 'max', inf);
   set(ud.valtxt,'string',sprintf('Value: [%0.2g, %0.2g]',min(thisData),max(thisData)));
   set(ud.absVal,'enable','on','backgroundcolor', SC.WINDOW_BG);
   set(ud.abstxt,'enable','on');
case {2,3} % using a distribution rather than data values
   set(ud.value,'clickincrement',1,'min',1,'max',10);
   set(ud.valtxt,'string','Value: [alpha %]');
   set(ud.absVal,'enable','off','value',1,'backgroundcolor',SC.CTRL_BG);
   set(ud.abstxt,'enable','off');
end


%-------------------------
%  SUBFUNCTION i_absval
%-------------------------
function i_absval(src,event,ud)

absval= get(src,'value');
if absval==1 % abs val? = Yes
   ud.value.min = 0;
else
   ud.value.min = -Inf;
end

%-------------------------
%  SUBFUNCTION i_userdef
%-------------------------
function i_userdef(src,event,ud)

check = get(src,'value');
SC = xregGui.SystemColorsDbl;

if check % = Yes
   set(ud.UserDef,'enable','on','backgroundcolor', SC.WINDOW_BG);
   set(ud.chooseFile,'enable','on');
   
   set([ud.seltxt,ud.abstxt,ud.optxt,ud.valtxt,ud.distxt],...
      'enable','off');
   set([ud.criteria,ud.absVal,ud.operator,ud.distribution],...
      'enable','off','backgroundcolor',SC.CTRL_BG);
   set(ud.value,'enable','off','backgroundcolor',SC.CTRL_BG);
else
   set(ud.UserDef,'enable','off','backgroundcolor',SC.CTRL_BG);
   set(ud.chooseFile,'enable','off');

   set([ud.seltxt,ud.abstxt,ud.optxt,ud.valtxt,ud.distxt],...
      'enable','on');
   set([ud.criteria,ud.absVal,ud.operator,ud.distribution],...
      'enable','on','backgroundcolor',SC.WINDOW_BG);
   set(ud.value,'enable','on','backgroundcolor',SC.WINDOW_BG);
   
   % Force absVal items to correct enable state
   i_criteria(src,event,ud);
end


%------------------------------------------------------
% SUBFUNCTION  i_chooseFile
%------------------------------------------------------
function i_chooseFile(src,event,ud)

[filename,pathname]=uigetfile('*.m', 'Custom selection criteria m-file:');

if filename==0 % user hit "Cancel"
   return
else
   [path,filename] = fileparts([pathname, filename]);
   set(ud.UserDef,'string', filename);
end
