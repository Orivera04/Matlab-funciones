function [m,OK]=gui_signalchooser(m,Action,varargin)
% XREGMODEL/GUI_SIGNALCHOOSER
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.8.4.4 $  $Date: 2004/04/04 03:30:21 $


switch lower(Action)
case 'figure'
	[m,OK]= i_Create(m,varargin{:});
	
case 'layout'
	lyt = i_CreateLyt(varargin{:});
	% return pointer
	m=lyt;
end
	



function [m,OK]= i_Create(m,S,Enable)

OK=0;
fH=findobj('tag','nam2sym');
if ~isempty(fH)
   figure(fH);
   return
end

if nargin<3
	Enable=1;
end

p  = xregpointer(m);

% Draw the figure
len=600;
height=300;
fH = xregdialog('resize','off', ...
    'name','Input Signal Setup',...
    'tag','nam2sym');
xregcenterfigure(fH, [len height]);

[lyt,udh] = i_CreateLyt(fH,p,S,Enable);

% Do the OK and CANCEL buttons.
uic{1}=uicontrol('parent',fH,...
   'style','pushbutton',...
   'position',[0,0,65,25],...
   'string','Cancel',...
   'callback','close(gcbf)');
uic{2}=uicontrol('parent',fH,...
   'style','pushbutton',...
   'position',[0,0,65,25],...
   'string','OK',...
   'callback',{@i_Update,udh});
helpbtn = mv_helpbutton(fH,'xreg_dataSel_matchSignal');
set(helpbtn,'position',[0 0 65 25]);

flowL= xregflowlayout(fH,'orientation','right/bottom',...
   'elements',{helpbtn,uic{:}},...
   'border',[0 10 0 10],...
   'gap',7);

% Finally put the mainFrame and the flowL
% into a xregborderlayout
mainBrdr= xregborderlayout(fH,...
   'center',lyt,...
   'south',flowL,...
   'innerborder',[5 40 5 5],...
   'container',fH,...
	'visible','on',...
   'packstatus','on');

fH.showdialog(uic{2});

tg = get(fH, 'tag');
OK= 0;
if strcmp(tg, 'ok');
    m= p.info;
    OK=1;
end
delete(fH);
freeptr(p);


function [mainFrame,udh] = i_CreateLyt(fH,p,s,Enable);

if isa(fH,'xregcontainer')
	mainFrame= fH;
	fH = allchild(0);
	udh= findobj(fH(1),'tag','SignalChooser');
	ud= get(udh,'userdata');

	
	m=  p.info;
	m= ChannelMatch(m,s);
	p.info= m;

	ud.Data= s;
	ud.pointer= p;
	
	
	ud= i_InitValues(ud);
	set(udh,'userdata',ud);
	
	return
	
end
	
	

m=  p.info;
m = ChannelMatch(m,s);
p.info= m;

ud.pointer = p;
ud.Data= s;


% Draw the ListView control

ud.ListCbk= @i_ListView;
callbacks= {'click','SigChooserList'
   'KeyUp','SigChooserList'};
ud.List = actxcontainer(...
   xregGui.listview(...
   [0 0 1 1],...
   fH,callbacks));
set(ud.List,'hideselection',0);
set(ud.List,'FullRowSelect',1);
set(ud.List,'labeledit',1);
set(ud.List,'View',3);

% make the columns for the listview
Cols= ud.List.ColumnHeaders;
Str={'Symbol','Signal Name','Stage'};
cwid= [50 100 50];
for i=1:3
   colItem= Cols.Add;
   set(colItem,'text',Str{i});
   set(colItem,'width',cwid(i));
end

nf= nfactors(m);
if isa(m,'xregtwostage')
	nf= [nlfactors(m) nf];
end
xi= xinfo(m);
Stage=1;

ListItems= ud.List.ListItems;
for i=1:nf(end)
   hand=ListItems.Add;
   set(hand,'text',xi.Symbols{i});
   set(hand,'SubItems',1,xi.Names{i});
	if i>nf(Stage);
		Stage= Stage+1;
	end
   set(hand,'SubItems',2,int2str(Stage));
end

% Make a title for this ListView
t= uicontrol('parent',fH,...
   'style','text',...
	'visible','off',...
   'horizontalalignment','left',...
	'FontWeight','bold',...
	'tag','SignalChooser',...
   'String','Model Input Factors');

udh= t;
ud.MTitle= t;

% Put the ListView into a xregborderlayout
listBrdr= xregborderlayout(fH,...
   'Center',ud.List,...
   'border',[0 0 0 10],...
   'packstatus','off');

selbutton= xregGui.iconuicontrol('parent',fH,...
   'imageFile',[xregrespath,'\leftarrow.bmp'],...
	'transparentColor', [255 255 0],...
	'ToolTip','Select Data Signal',...
 	'visible','off',...
   'callback',{@i_select,udh,'open'});
ud.CopyRange=uicontrol('parent',fH,...
   'style','checkbox',...
	'visible','off',...
   'string','Copy range');

selBrdr= xreggridlayout(fH,...
   'correctalg','on',...
   'dimension',[5,1],...
   'elements',{[],selbutton,[],ud.CopyRange,[]},...
   'rowsizes',[10 80 5 20 -1]);

% listbox with all Names
ud.namelist=uicontrol('parent',fH,...
   'style','listbox',...
	'visible','off',...
   'tag','Symlist2',...
   'backgroundcolor',[1 1 1],...
   'string','',...
   'callback',{@i_select,udh});

% Make a title for this ListBox
t= uicontrol('parent',fH,...
   'style','text',...
	'visible','off',...
	'HorizontalAlignment','left',...
   'String','Units:',....
	'position',[0 0 80 15]);
ud.Units=uicontrol('parent',fH,...
   'style','text',...
	'visible','off',...
	'HorizontalAlignment','left',...
	'callback',{@i_ChangeUnits,udh},...
	'position',[0 0 120 15]);
UM= xreggridlayout(fH,'dimension',[1 2],...
	'elements',{t,ud.Units});

% Input Factor Range
t= uicontrol('parent',fH,...
   'style','text',...
	'visible','off',...
	'HorizontalAlignment','left',...
   'String','Model range:',....
	'position',[0 0 80 15]);
ud.Mrange(1)= uicontrol('parent',fH,...
   'style','text',...
	'visible','off',...
	'HorizontalAlignment','left',...
	'position',[0 0 80 15]);
ud.Mrange(2)= uicontrol('parent',fH,...
   'style','text',...
	'visible','off',...
	'HorizontalAlignment','left',...
	'position',[0 0 80 15]);

GM= xreggridlayout(fH,'dimension',[1 3],...
	'elements',{t,ud.Mrange(1),ud.Mrange(2)},...
	'correctalg','on',...
	'colsizes',[-1 60 60],...
	'gapx',10);

mframe= xregframetitlelayout(fH,...
	'Title','Selected input factor',...
	'center',xreggridlayout(fH,...
	'dimension',[2 1],...
   'elements',{UM,GM},...
	'correctalg','on',...
	'gapy',10,...
	'rowsizes',[20 20]));


ud.DTitle= uicontrol('parent',fH,...
   'style','text',...
	'visible','off',...
   'horizontalalignment','left',...
	'FontWeight','bold',...
   'String','All Data Signals');

t= uicontrol('parent',fH,...
   'style','text',...
	'visible','off',...
	'HorizontalAlignment','left',...
   'String','Units:',....
	'position',[0 0 80 15]);
ud.DUnits=uicontrol('parent',fH,...
   'style','text',...
	'visible','off',...
	'HorizontalAlignment','left',...
	'callback',{@i_ChangeUnits,udh},...
	'position',[0 0 120 15]);
DUM= xreggridlayout(fH,'dimension',[1 2],...
	'elements',{t,ud.DUnits});
% Data Signal Range 
t= uicontrol('parent',fH,...
   'style','text',...
	'visible','off',...
	'HorizontalAlignment','left',...
   'String','Data range:',....
	'position',[0 0 80 15]);
ud.Drange(1)= uicontrol('parent',fH,...
   'style','text',...
	'visible','off',...
	'HorizontalAlignment','left',...
	'position',[0 0 80 15]);
ud.Drange(2)= uicontrol('parent',fH,...
   'style','text',...
	'visible','off',...
	'HorizontalAlignment','left',...
	'position',[0 0 80 15]);
DM= xreggridlayout(fH,'dimension',[1 3],...
	'correctalg','on',...
	'colsizes',[-1 60 60],...
	'elements',{t,ud.Drange(1),ud.Drange(2)},...
	'gapx',10);

dframe= xregframetitlelayout(fH,...
	'Title','Selected data signal',...
	'center',xreggridlayout(fH,...
	'dimension',[2 1],...
   'elements',{DUM,DM},...
	'correctalg','on',...
	'gapy',10,...
	'rowsizes',[20 20]));

mainFrame= xreggridlayout(fH,...
	'dimension',[3 3],...
   'elements',{ud.MTitle,ud.List,mframe, [],selBrdr,[], ud.DTitle,ud.namelist,dframe},...
	'correctalg','on',...
   'border',[10 10 10 10],...
	'gapx',10,...
	'rowsizes',[18,-1 80],...
   'colsizes',[-1 80 -1]);

% make the first node selected in the List box
n1= ud.List.ListItems.Item(1);
set(ud.List,'selecteditem',n1);

set(udh,'userdata',ud)

i_InitValues(ud);






function ud= i_InitValues(ud)

m= ud.pointer.info;
nf= nfactors(m);
if isa(m,'xregtwostage')
	nf= [nlfactors(m) nf];
end
xi= xinfo(m);
Stage=1;

ListItems= ud.List.ListItems;
for i=1:nf(end)
	hand= ListItems.Item(i);
	% set the target name to be curname
   set(hand,'SubItems',1,xi.Names{i});
	if i>nf(Stage);
		Stage= Stage+1;
	end
   set(hand,'SubItems',2,int2str(Stage));
end

i_setValues(ud,1);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_setValues 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_setValues(ud,Ind);

m= ud.pointer.info;
xi= xinfo(m);

[d,DataList]= i_GetData(ud,Ind);

AllNames= get(DataList,'name');

mind= find(strcmp(xi.Names{Ind},AllNames));
set(ud.namelist,...
	'string',AllNames,...
	'value',mind,....
	'ListBoxTop',max(mind-5,1));

Bnds= getcode(m,Ind);
set(ud.Mrange(1),'string',num2str(Bnds(1)) );
set(ud.Mrange(2),'string',num2str(Bnds(2)) );

muc= xi.Units{Ind};
set(ud.Units,'string',char(muc))


DataList= DataList(:,mind);
i_showDataRanges(ud,DataList,muc);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_showDataRanges 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_showDataRanges(ud,d,muc)

if ~nargin
	% data ranges
	udh= findobj(gcbf,'tag','SignalChooser');
	ud= get(udh,'userdata');
	Ind= double(get(ud.List.SelectedItem,'index'));
	d= i_GetData(ud,Ind);
	
	m= ud.pointer.info;
	xi= xinfo(m);
	muc= xi.Units{Ind};
end
uc= get(d,'units');
uc= uc{1};

set(ud.DUnits,'string',char(uc))
d= double(d);
minD= min(d);
maxD= max(d);
set(ud.Drange(1),'string',minD,'userdata',minD);
set(ud.Drange(2),'string',maxD,'userdata',maxD);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_showDataRanges 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [d,DataList]= i_GetData(ud,Ind);

if nargin==1
	Ind= double(get(ud.List.SelectedItem,'index'));
end
DataList= ud.Data;

dind= get(ud.namelist,'value');
if dind>size(DataList,2);
	dind=1;
end
d= DataList(:,dind);

% --------------------------------------------------
% function i_select
% --------------------------------------------------
function i_select(h,evt,udh,mode);

Next=0;
if nargin<4
	mode=get(gcbf,'selectiontype');
	Next= strcmp(mode,'open');
	udh= findobj(gcbf,'tag','SignalChooser');
end
switch mode
case 'normal'
	i_showDataRanges;
case 'open'
	ud=get(udh,'userdata');
	fH= get(udh,'parent');
	
	m= ud.pointer.info;
	
	
	if get(ud.CopyRange,'value')
		m= i_SetRange(m,ud);
	end

	
	% get handles
	target=ud.List.selecteditem;
	curlst=ud.namelist;
	
	% get the variable name to change
	AllNames=get(curlst,'string');
	Ind= get(curlst,'value');
	curName=AllNames{Ind};
	
	% set the target name to be curname
	set(target,'subitems',1,curName);
	
	% Get the number of nodes
	N= ud.List.Listitems.Count;
	% Get the current index
	curInd= double(target.index);
	
	d= i_GetData(ud,curInd);
	% update model input names
	xi= xinfo(m);
	xi.Names(curInd) = get(d,'Name');
    % set units if unit checking is not on
    xi.Units(curInd)= get(d,'units');
    m= xinfo(m,xi);
    
    m= ChannelMatch(m,ud.Data);
	ud.pointer.info  = m;
    
    set(udh,'userdata',ud);
	
	if Next
		newInd= mod(curInd+1,double(N)+1);
		% make sure indexing starts from 1 not 0
		if newInd==0,newInd=1;end
		% increment the selected item by one
		newItem= ud.List.Listitems.Item(newInd);
		set(ud.List,'selecteditem',newItem);
	else
		newInd=curInd;
	end
	
	i_setValues(ud,newInd);
end
		


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_Update
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_Update(h,evt,udh)
ud= get(udh,'userdata');
fH= get(udh,'parent');
listItems= ud.List.ListItems;
m= ud.pointer.info;
NameList= factorNames(m);
if length(unique(NameList))~=length(NameList)
    errordlg('Factors must be unique.','Data Error','modal');
else
    % Close the dialog with ok status
    set(fH, 'tag', 'ok', 'visible', 'off');
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_DataRange 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_DataRange(h,evt,udh)
ud= get(udh,'userdata');
m = ud.pointer.info;
m= i_SetRange(m,ud);
i_select(1,1,udh,'open');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_SetRange 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function m= i_SetRange(m,ud);

ind= double(get(ud.List.SelectedItem,'index'));

[Bnds,g,tgt]= getcode(m);
xi= xinfo(m);

vals= get(ud.Drange(:),'userdata');
vals= [vals{:}];
if vals(1)==vals(2)
	if vals(1)==0
		vals(2)=1;
	else
		vals(2)= vals(1)*1.1;
	end
end
mu= xi.Units{ind};
xu= get(i_GetData(ud,ind),'units');

Bnds(ind,:)= vals;
if isa(m,'xregtwostage')
   if ind<=nlfactors(m)
      tgt(ind,:)= recommendedTgt(get(m,'local'));
   else
       if ~isSameTgt(m)
           tgt(ind,:)= Bnds(ind,:);
       else
           G= get(m,'baseglobal');
           tgt(ind,:)= recommendedTgt(G);
       end
   end
else
   tgt(ind,:)= recommendedTgt(m);
end
m = setcode(m,Bnds,g,tgt);
m = completecopymodel(m);

ud.pointer.info= m;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_ChangeUnits 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_ChangeUnits(h,evt,udh)

ud= get(udh,'userdata');
m = ud.pointer.info;
ind= double(get(ud.List.SelectedItem,'index'));

xi= xinfo(m);
xi.Units{ind}= junit(get(gcbo,'string'));
m= xinfo(m,xi);
m = ChannelMatch(m,ud.Data);
ud.pointer.info= m;
set(udh,'userdata',ud);
i_setValues(ud,ind);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_ListView
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_ListView(ud);
ind= double(get(ud.List.SelectedItem,'index'));
i_setValues(ud,ind);
