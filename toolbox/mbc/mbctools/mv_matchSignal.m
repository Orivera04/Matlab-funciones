function [ssf, OK] = mv_matchsignal(varargin)
%% [SSF, OK] = MV_MATCHSIGNAL(SSF, NAMES)
%% takes a sweepsetfilter and a cell array of strings (signal names)
%% returns a sweepsetfilter with new variables user has matched
%% to these signal names

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.3 $  $Date: 2004/02/09 08:20:48 $



fH=i_Create(varargin{:});

waitfor(fH,'tag')
ud = get(fH,'userdata');
switch lower(get(fH,'tag'))
case 'close'
   ssf = ud.ssf;
   OK = ud.OK;
case 'cancel'
   ssf = ud.ssf;
   OK = 0;
end
close(fH);
return
% --------------------------------------------------
% function i_create
% --------------------------------------------------
function fH=i_Create(ssf,namesToMatch)

ud.ssf = ssf;
ud.OK=0;
ud.factors = namesToMatch;

bgc= get(0,'defaultuicontrolbackgroundcolor');
% Draw the figure
len=450;
height=300;
Scr= get(0,'screensize');
fPos= [Scr(3)/2-len/2 Scr(4)/2-height/2, len, height];
fH=xregfigure('menubar','none',...
   'position',fPos,...
   'tag','data2factors',...
   'name','Match Data Variables To Input Factors',...
   'resize','off',...
   'color',bgc,...
   'visible','off',...
   'WindowStyle','modal',...
   'numbertitle','off');
fH = double(fH);
% Draw the ListView control
ud.List = actxcontainer(...
   xregGui.listview(...
   [0 0 1 1],...
   fH));
set(ud.List,'hideselection',0);
set(ud.List,'labeledit',1);
set(ud.List,'View',3);
% make the columns for the listview
Cols= ud.List.ColumnHeaders;
Str={'Symbol','Data Name'};
for i=1:2
   colItem= Cols.Add;
   set(colItem,'text',Str{i});
   set(colItem,'width',80);
end

% -----Add the symbols and names to the list-----
mapping=1:length(namesToMatch);
%available names in sweepset
allNam=get(ssf,'name');
%% find any that match
for i=1:length(namesToMatch)
   ind = strmatch(namesToMatch(i),allNam,'exact');
   if ~isempty(ind)
      mapping(i)=ind;
   end
end

matchedNames= allNam(mapping);

ListItems= ud.List.ListItems;
for i=1:length(namesToMatch)
   hand=ListItems.Add;
   set(hand,'text',namesToMatch{i});
   set(hand,'SubItems',1,matchedNames{i});
end
% Make a title for this ListView
t= uicontrol('parent',fH,...
   'style','text',...
   'horizontalalignment','left',...
   'String','Data Variables Matched to Inputs');

% Put the ListView into a BorderLayout
listBrdr= xregborderlayout(fH,...
   'Center',ud.List,...
   'innerborder',[0 0 0 40],...
   'North',t,...
   'packstatus','off');

% now build the Select button
selbutton= xregGui.iconuicontrol('parent',fH,...
   'imageFile',[xregrespath,'\leftarrow.bmp'],...
	'transparentColor', [255 255 0],...
	'ToolTip','Select Data Signal',...
   'callback',@i_select);


% add the selectbutton to a BorderLayout with BIG borders
selBrdr= xregborderlayout(fH,...
   'Center',selbutton,...
   'border',[0 50 0 50]);

% listbox with all Names
ud.namelist=xreguicontrol('parent',fH,...
   'style','listbox',...
   'tag','Symlist2',...
   'backgroundcolor',[1 1 1],...
   'string',allNam,...
   'callback',{@i_listselect});
% Make a title for this ListBox
t= xreguicontrol('parent',fH,...
   'style','text',...
   'String','All Data');

% add the listbox to a BorderLayout
listboxBrdr= xregborderlayout(fH,...
   'center',ud.namelist,...
   'innerborder',[0 0 0 40],...
   'north',t);

% Now put the ListView, Select Button and ListBox into a grid
mainGrid= xreggridlayout(fH,...
   'dimension',[1 3],...
   'elements',{listBrdr,selBrdr,listboxBrdr},...
   'gapx',10,...
   'colratios',[0.5 0.15 0.35]);

%% explanatory text
t= xreguicontrol('parent',fH,...
   'style','text',...
   'horiz','left',...
   'String',['The current data set does not have signals ',...
      'matching every name of the model input factors.',...
      ' Please match data signals to the model inputs.']);

mainGrid= xreggridlayout(fH,...
   'dimension',[2 1],...
   'elements',{t,mainGrid},...
   'gapy',10,...
   'correctalg','on',...
   'border',[10 10 10 0],...
   'rowsizes',[40, -1]);

% Put the mainGrid into a Frame layout
mainFrame= xregframetitlelayout(fH,...
   'center',mainGrid,...
   'border',[10 20 10 10]);

% Do the APPLY and CANCEL buttons.
uic{1}=xreguicontrol('parent',fH,...
   'style','pushbutton',...
   'position',[0,0,70,25],...
   'string','Cancel',...
   'callback','set(gcbf,''tag'',''Cancel'')');

uic{2}=xreguicontrol('parent',fH,...
   'style','pushbutton',...
   'position',[0,0,65,25],...
   'string','OK',...
   'callback',{@i_update});

helpbtn = mv_helpbutton(fH,'xreg_modEval_matchSignal');
set(helpbtn,'position',[0 0 65 25]);

flowL= xregflowlayout(fH,'orientation','right/bottom',...
   'elements',{helpbtn,uic{:}},...
   'border',[0 10 0 10],...
   'gap',7);

% Finally put the mainFrame and the flowL
% into a borderlayout
mainBrdr= xregborderlayout(fH,...
   'center',mainFrame,...
   'south',flowL,...
   'innerborder',[5 30 5 5],...
   'container',fH,...
   'packstatus','on');

% make the first node selected in the List box
n1= ud.List.ListItems.Item(1);
set(ud.List,'selecteditem',n1);
set(fH,'userdata',ud,'visible','on');


% --------------------------------------------------
% function i_listselect
% --------------------------------------------------
function i_listselect(src,null)
mode=get(gcbf,'selectiontype');
if strcmp(mode,'normal');
   return
else i_select([],[]);
end

% --------------------------------------------------
% function i_select
% --------------------------------------------------
function i_select(src, null)
fH= findobj('tag','data2factors');
ud=get(fH,'user');

% get handles
target=ud.List.selecteditem;
curlst=ud.namelist;

% get the variable name to change
AllNames=get(curlst,'string');
curName=AllNames{get(curlst,'value')};

% set the target name to be curname
set(target,'subitems',1,curName);

% Get the number of nodes
N= ud.List.Listitems.Count;
% Get the current index
curInd= target.index;
newInd= mod(double(curInd)+1,double(N)+1);
% make sure indexing starts from 1 not 0
if newInd==0,newInd=1;end
% increment the selected item by one
newItem= ud.List.Listitems.Item(newInd);
set(ud.List,'selecteditem',newItem);

% --------------------------------------------------
% function i_update
% --------------------------------------------------
function i_update(src,null)

fH= findobj('tag','data2factors');
ud= get(fH,'userdata');
ssf = ud.ssf;

listItems= ud.List.ListItems;
for i=1:double(listItems.Count)
   h= listItems.Item(i);
   NameList{i}= h.SubItems(1);
end

%% check we have unique factor names from matching
if length(unique(NameList))==length(NameList)
    %% new to create the variables we need
    newNames = ud.factors;
    %% find the names we need to add
    for i=find(~ismember(NameList,newNames))
        ssf = addVariable(ssf,[newNames{i} ' = ' NameList{i}]);
    end
    %% only need the vars we chose in the matching
    ssf=addVarsFilter(ssf,{NameList{:} newNames{:}});
    ud.OK=1;
    ud.ssf = ssf;
else
    errordlg('Factors must be unique.','Data Error','modal');
    ud.OK=0;
end

set(fH,'userdata',ud,'tag','close');
