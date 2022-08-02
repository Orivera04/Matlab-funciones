function [sout,ok]=gui_sweepchooser(allPtrs,action,varargin)
% SWEEPCHOOSER  choose a subset of sweeps from a list of sweepsets
%
%   [SOUT,OK]=SWEEPCHOOSER(S) pops up a modal gui for selecting
%   a set of individual sweeps from a list of sweepsets in S.
%   [SOUT,OK]SWEEPCHOOSER(S,'figure',opts) creates a gui and passes
%   optional additional data in in parameter-value pairs.  These options
%   are:
%        'stype'        - stype number to use for filtering
%        'filterlogs'   - vector of log numbers to use for filtering
%        'symbols'      - cell array of symbols to use instead of variables
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.10.4.6 $  $Date: 2004/04/12 23:34:59 $

if nargin<2
   action='figure';
end

switch lower(action)
case 'layout'
   sout=i_createlyt(allPtrs,varargin{:});
   set(sout,'packstatus','on');
   ok=1;
case 'figure'
   [sout,ok]=i_createfig(allPtrs,varargin{:}); 
case 'selchng'
   i_selchng(varargin{1});
case 'sweepinfo'
   %% needed until selectfcn of listitemselector can be done with fcn handles
   i_sweepinfo(varargin{1});
end
return

% ---------------------------------------------------------------------------------------
%   subfunction i_createfig
% ---------------------------------------------------------------------------------------
function [sout,ok]=i_createfig(allPtrs,varargin)
scr=get(0,'screensize');
figh=xregfigure('visible','off',...
   'Windowstyle', 'modal', ...
   'menubar','none',...
   'toolbar','none',...
   'numbertitle','off',...
   'name','Select Data for Evaluation',...
   'tag','sweepchooser',...
   'color',get(0,'defaultuicontrolbackgroundcolor'),...
   'resize','off',...
   'closerequestfcn','set(gcbf,''tag'',''cancel'');');
figh=double(figh);
xregcenterfigure(figh,[510 550]);

% add ok, cancel
okbtn=uicontrol('style','pushbutton',...
   'parent',figh,...
   'string','OK',...
   'position',[0 0 65 25],...
   'callback','set(gcbf,''tag'',''ok'');');
cancbtn=uicontrol('style','pushbutton',...
   'parent',figh,...
   'string','Cancel',...
   'position',[0 0 65 25],...
   'callback','set(gcbf,''tag'',''cancel'');');   
helpbtn=mv_helpbutton(figh,'xreg_selectEvalData');
set(helpbtn,'position',[0 0 65 25]);

%% i_createlyt = make gui components
%% calls i_SetValues which initialises the gui
lyt=i_createlyt(allPtrs,figh,varargin{:});

flwok=xregflowlayout(figh,'orientation','right/center','elements',{helpbtn,cancbtn,okbtn},...
   'gap',7,'border',[0 0 -7 0]);
figlyt=xregborderlayout(figh,'container',figh,'center',lyt,...
   'south',flwok,'innerborder',[10 45 10 10],'packstatus','on');

set(figh,'visible','on');

%%%%%%%%%%%%%%%%%%%%%%%%%%
%% for testing
% return
%%%%%%%%%%%%%%%%%%%%%%%%%%

waitfor(figh,'tag');

tg=get(figh,'tag');
ud = get(figh,'userdata');
switch lower(tg)
case 'ok'
   sout=ud.current.info;
   %% if some data chosen, check we did match the names    
   if get(ud.dataChoice,'value')~=1 & ~all(ismember(ud.factors,get(sout,'name')))
      ok=0;
      delete(figh);
      return
   end
   
   %% filter on the testnums from the listitemselector
   selind= get(ud.ls,'selecteditems');
   %% next line will also convert ssf into ss
   sout = sout(:,:,ismember(testnum(sout),selind));
   sout= sout(all(~isbad(sout),2),:);
   ok=find(get(ud.dataChoice,'value'));
case 'cancel'
   sout=[];
   ok=0;
end
delete(figh);
freeptr(ud.current);
freeptr(ud.matched);
return



% ---------------------------------------------------------------------------------------
%   subfunction i_createlyt
% ---------------------------------------------------------------------------------------
function lyt = i_createlyt(allPtrs,figh,varargin);

ud.originals=allPtrs;
ud.figure = figh;
ud.filterlogs=[];
%% current holds (pointer to) ss that we will be using
ud.current= xregpointer(allPtrs(1).sweepset);
ud.matched= xregpointer(allPtrs(1).sweepset);

rbenable = [true true true];
if length(varargin)
   for n=1:2:length(varargin)
      switch lower(varargin{n})
      case 'filterlogs'
         ud.filterlogs=varargin{n+1};
      case 'factornames'
         ud.factors=varargin{n+1};
      case 'availableoptions'
         rbenable=varargin{n+1};
      end
   end
end

%%
%%  ======== GUI COMPONENTS ==============
%%
%% the list of data sets
ud.allSweeps=uicontrol('parent',figh,...
   'style','listbox',...
   'tag','sweepsListbox',...
   'backgroundcolor','w');
%% info about selected data set (on right)
ud.sweepsetinfo=uicontrol('parent',figh,...
   'style','text',...
   'horizontalalignment','left');
%% checkbox for filter out used log numbers
ud.filter=uicontrol('parent',figh,...
   'style','checkbox',...
   'string','Filter out used test numbers',...
   'value',1);

a=xregGui.listview([0 0 1 1],figh);
ch=a.columnheaders;
i1=ch.Add;
i2=ch.Add;
i1.text='Variable';
i2.text='Value';
i1.width=75;
i2.width=80;
a.view=3;
ud.sweepinfo=actxcontainer(a);
ud.sweepnum=uicontrol('parent',figh,...
   'style','text',...
   'horizontalalignment','left',...
   'string','Test number:');
%% sweep chooser twin listbox thing
ud.ls=listitemselector(figh,'selectionstyle','multiple',...
   'selectedtitle','Selected tests:',...
   'unselectedtitle','Unselected tests:');

udh=sprintf('%20.15f',ud.allSweeps);


frm1=xregframetitlelayout(figh,'title','Data info',...
   'center',ud.sweepsetinfo,...
   'innerborder',[15 5 5 5],...
   'packstatus','off',...
   'border',[10 0 0 0]);

%% checks to choose the data for fitting
ud.dataChoice=xregGui.rbgroup(figh,'nx',1,'ny',3,...
   'enablearray',rbenable,...
   'string',{'View model without data';...
      'Evaluate using fit data';'Evaluate using other data'});

brd1=xreggridbaglayout(figh,...
   'dimension',[2,2],...
   'mergeblock',{[1 1],[1 2]},...
   'elements',{ud.dataChoice, ud.allSweeps, [], frm1},...
   'correctalg','on',...
   'gapy',20',...
   'rowsizes',[50, -1],...
   'colsizes',[130, -1]);
frm2=xregframetitlelayout(figh,'title','Data set',...
   'center',brd1,...
   'innerborder',[15 10 10 10],...
   'border',[0 5 0 0]);
grd1=xreggridlayout(figh,'correctalg','on','dimension',[2 1],...
   'rowsizes',[20 -1],...
   'elements',{ud.sweepnum,ud.sweepinfo});
frm3=xregframetitlelayout(figh,'title','Test info',...
   'center',grd1,...
   'innerborder',[10 5 5 5],...
   'border',[10 0 0 0]);
brd2=xregborderlayout(figh,...
   'east',frm3,...
   'center',ud.ls,...
   'innerborder',[0 0 200 0]);
grd=xreggridlayout(figh,'correctalg','on',...
   'dimension',[2 1],...
   'rowsizes',[25 -1],...
   'elements',{ud.filter,brd2});
frm4=xregframetitlelayout(figh,...
   'title','Tests',...
   'innerborder',[15 10 10 10],...
   'center',grd,...
   'border',[0 0 0 5]);
lyt=xregborderlayout(figh,'north',frm2,...
   'center',frm4,...
   'innerborder',[0 0 0 250]);

set(figh,'userdata',ud);

ud=i_setvalues(figh,[],ud);

set(ud.ls,'callback',{@i_refilter,ud});
set(ud.allSweeps,'callback',{@i_datainfo,ud});
set(ud.filter,'callback',{@i_refilter,ud});
set(ud.ls,'selectfcn','gui_sweepchooser([],''sweepinfo'',%INDEX%)');
set(ud.dataChoice,...
   'callback',{@i_radio,ud.allSweeps,frm1,frm4,frm3});

set(ud.allSweeps,'enable','off');
set(frm1,'enable','off');
set(frm4,'enable','off');
set(frm3,'enable','off');

% check the view is correct for initial RB selection
indx = find(rbenable);
if any(indx==2)
   indx_start = 2;
else
   indx_start = indx(1);
end
ud.dataChoice.selected = indx_start;
if indx_start~=2
   i_radio(ud.dataChoice,[],ud.allSweeps,frm1,frm4,frm3);
end
return

% ---------------------------------------------------------------------------------------
%   subfunction i_setvalues
% ---------------------------------------------------------------------------------------
function ud=i_setvalues(src,null,ud)

mbh = MBrowser;
% set up string in sweepset list box and info field
allPtrs = ud.originals;
str={};
for n=1:length(allPtrs);
   str{n}=allPtrs(n).get('label');
end
set(ud.allSweeps,'string',str);

%% set current data set to be the one used for modelling
%% get pointer to parent ssf for this testplan
dp = DataLinkPtr(mbh.currentnode.mdevtestplan);
curName = dp.get('label');
val = find( ismember(str,curName) );

%% select this data set in the listbox
set(ud.allSweeps,'value',val);
%% get the sweepset
ssf = sweepsetfilter(allPtrs(val));
ssf = addVarsFilter(ssf,ud.factors);

%% store this as a sweepset
ss = sweepset(ssf);
ud.matched.info=ss;

%% put comments about the current ss in text on right
set(ud.sweepsetinfo,'string',cellstr(char(ss)));

% decide whether there is data to filter against (may have been passed in)
% curSS then only contains the sweep nums we're allowing
if isempty(ud.filterlogs)
   set(ud.filter,'value',0,'enable','off');
else
   set(ud.filter,'enable','on','value',1);
   ss=ss(:,:,~ismember(testnum(ss),ud.filterlogs));
end
ud.current.info = ss;

%% put testnums in the listitemselector
tn=testnum(ss);
set(ud.ls,'itemlist',tn);
% select all by default
selectitems(ud.ls,[1:length(tn)]);

return


% ---------------------------------------------------------------------------------------
%   subfunction i_refilter
% ---------------------------------------------------------------------------------------
function i_refilter(src,null,ud)

%% checkbox
filt=get(ud.filter,'value');

ss = ud.matched.info;

if filt %% if checked throw out all testnums in filterlogs
   ss=ss(:,:,~ismember(testnum(ss),ud.filterlogs));
end
ud.current.info= ss;
% get current selected test numbers
old_selind= get(ud.ls,'selecteditems');
new_selind = find(ismember(testnum(ss),old_selind));
%% select all possible testnums from the current sweepset matching old selindices
% do this in the listitemselector
set(ud.ls,'itemlist',testnum(ss));
selectitems(ud.ls,new_selind);

i_sweepinfo(1,[],ud);

return

% ---------------------------------------------------------------------------------------
%   subfunction i_sweepinfo
% ---------------------------------------------------------------------------------------
function i_sweepinfo(src,null,ud,inds);
%% click on a  sweep and see its values

if nargin<4 
   %% needed until selectfcn of listitemselector can be done with fcn handles
   ud=get(findobj(0,'type','figure','tag','sweepchooser'),'userdata');
   inds = src;
end

if isempty(ud)
   ud=get(findobj(0,'type','figure','tag','sweepchooser'),'userdata');
end

li=ud.sweepinfo.listitems;
if length(inds)==1 
   ss=ud.matched.info;
   ss=ss(:,:,inds);
   mn=mean(ss);
   for n=1:length(mn);
      item= li.Item(n);
      set(item,'subitems',1,num2str(mn(n)));
   end
   set(ud.sweepnum,'string',['Test number:  ' sprintf('%d',testnum(ss))]);
end
if isempty(ud.current.info) | length(inds)~=1
   % clear out values
   for n=1:ud.current.size(2)
      item= li.Item(n);
      set(item,'subitems',1,'');     
   end
   set(ud.sweepnum,'string','Test number:');
end
return



% ---------------------------------------------------------------------------------------
%   subfunction i_datainfo
% ---------------------------------------------------------------------------------------
function i_datainfo(src,null,ud)

%% in createFig we need to call this subfunction with a handle
if isempty(ud)
   figH=findobj(0,'type','figure','tag','sweepchooser');
   ud=get(figH,'userdata');
end

allPtrs= ud.originals;
%% find which datset chosen in listbox
val=get(ud.allSweeps,'value');
fullssf=sweepsetfilter(allPtrs(val));
%% initialize ssf as the full sweepsetfilter
ssf=fullssf;

%% check there are enough factors in this sweepset
if length(ud.factors)>length(get(ssf,'name'))
   errordlg('This data set contains too few factors to evaluate the current model.',...
      'Data Error','modal');
   return
end

% if factor names are available in data set, remove extra signals
if all(ismember(ud.factors,get(ssf,'name')))
   ssf = addVarsFilter(ssf,ud.factors);
end

%% show information about original on right of listbox
set(ud.sweepsetinfo,'string',deblank(char(fullssf))); %this is the original: with all vars

%% check if variables exist in this sweepset - if not, throw up signal matching
if ~all(ismember(ud.factors,get(ssf,'name')))
   [ssf,matchOK] = mv_matchSignal(ssf, ud.factors);
   %% returns ssf with variables we need and the original vars that were used
   ssf = addVarsFilter(ssf,ud.factors);
   if ~matchOK
      %% ud.matched still empty
      %% reset data choice to modelling data
      ud=i_setvalues([],[],ud);
      i_sweepinfo(1,[],ud);
      return
   end
end

ss = sweepset(ssf);
%% ud.matched points to original or matched version
ud.matched.info=ss;
tn=testnum(ss);

% put the testnums into the listitemselector
% first filter out used tests??
if get(ud.filter,'value')
   ss=ss(:,:,~ismember(testnum(ss),ud.filterlogs));
end
tn=testnum(ss);
set(ud.ls,'itemlist',tn);
% select all by default
selectitems(ud.ls,[1:length(tn)]);

%% current sweepset is
ud.current.info=ss;


%% put var names into ActiveX thingy: no values displayed yet
varn=get(ss,'name');
li=ud.sweepinfo.listitems;
li.Clear;
for n=1:length(varn)
   h=li.Add;
   h.text=varn{n};
end

set(ud.sweepnum,'string','Test number:');
if ~isempty(tn)
   i_sweepinfo(ud.allSweeps,[],ud,1);
end

return

% ---------------------------------------------------------------------------------------
%   subfunction i_radio
% ---------------------------------------------------------------------------------------
function i_radio(src,null,varargin)

ud=get(findobj(0,'type','figure','tag','sweepchooser'),'userdata');

val=get(src,'selected');
if val==3
   for i=1:length(varargin)
      set(varargin{i},'enable','on');
   end
   % decide whether there is data to filter against
   if isempty(ud.filterlogs)
      set(ud.filter,'value',0,'enable','off');
   end
   %% set data to be the current choice and see if we need matchSignal
   i_datainfo([],[],[]);
else
   for i=1:length(varargin)
      set(varargin{i},'enable','off');
   end
   %% set activeX listview to have nothing selected
   li = ud.sweepinfo.listitems;
   invoke(li,'clear');
end
return
