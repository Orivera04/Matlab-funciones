function [data, inds, ok]=uisortdata(data,symb,action)
%UISORTDATA GUI for sorting matrices by row
%  UISORTDATA is a gui function which sorts the rows of an input matrix
%  and returns the sorted matrix and, if desired, the index used for the
%  sort.
%
%  Usage:
%        data=uisortdata(data,symbols)
%        [data,inds,ok]=uisortdata(data,symbols)
%
%        Where data is the data matrix to be sorted and symbols is a cell
%        array of strings indicating the headings of each column of data in
%        the data matrix.  The function returns the sorted data matrix and
%        optionally an index list such that OUTPUT=INPUT(inds,:).  The flag
%        "ok" indicates whether the user pressed Sort (ok=1) or Cancel
%        (ok=0).
%
%  Alternatively, if the symbols is left empty or not entered then symbols
%  'col1':'colN' will be generated automatically.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.4 $  $Date: 2004/04/04 03:29:33 $


if nargin==0
   return
end

if nargin==1
   % generate symbols
   symb=[];
end

if nargin<3
   if isempty(data)
      % nothing to sort
      inds=[];
      return
   elseif isempty(symb)
      % generate symbols
      for m=1:size(data,2)
         symb{m}=['col' int2str(m)];
      end
   elseif length(symb)~=size(data,2)
      % bad inputs
      error('Input data does not have the same number of columns as there are sort factors');
   end
   action = 'figure';
end

[data,inds,ok]=i_createfig(data,symb);




function [data,inds,ok]=i_createfig(data,symb)

numc=size(data,2);

scrsz=get(0,'screensize');
srtfig=xregdialog('position',[scrsz(3)/2-250 scrsz(4)/2-80 485 215],...
   'name','Sort',...
   'resize', 'off');

% Text and control for altering number of sort variables
ctrl=xregGui.clickedit(srtfig,...
   'min',1,...
   'max',numc,...
   'value',numc,...
   'rule','int',...
   'dragincrement',1,...
   'clickincrement',1,...
   'callback',@i_nsort);
srtud.Hand.nsortf=xregGui.labelcontrol('parent',srtfig,...
   'string','Number of sort variables:',...
   'labelsize',120,...
   'labelsizemode','absolute',...
   'controlsize',60,...
   'controlsizemode','absolute',...
   'gap',10,...
   'control',ctrl);

% Radiobuttons for selecting ascend, descend or randomise
srtud.Hand.rbg=xregGui.rbgroup(srtfig,...
   'ny',4,'nx',1,...
   'string',{'Ascending';'Descending';'Custom';'Random'},...
   'value',[1; 0; 0; 0],...
   'callback',@i_radiosel);

lsttbl=xregtable(double(srtfig),'position',[0 0 150 50],...
   'frame.visible','off',...
   'hslider.width',12,...
   'defaultcelltype','uipopupmenu',...
   'frame.hborder',[0 0],...
   'frame.vborder',[0 2],...
   'cols.size',60,...
   'cols.spacing',5,...
   'cellchangedcallback',@i_swapsel,...
   'redrawmode','basic');
set(lsttbl,'cells.rowselection',[1 1],...
   'cells.colselection',[1 numc],...
   'cells.type','uitext',...
   'cells.colselection',[1 1],...
   'cells.string','Sort by:',...
   'cells.colselection',[2 numc],...
   'cells.string','then by:',...
   'cells.rowselection',[2 2],...
   'cells.colselection',[1 numc],...
   'cells.string',{symb},...
   'cells.value',(1:numc),...
   'cells.backgroundcolor',[1 1 1]);
lsttbl.redrawmode='normal';
srtud.Hand.sortlist=lsttbl;

% Custom expression box
srtud.Hand.custedt=uicontrol('style','edit',...
   'parent',srtfig,...
   'string','',...
   'horizontalalignment','left');

% OK and Cancel buttons
cancbtn=uicontrol('style','pushbutton',...
   'string','Cancel',...
   'callback','set(gcbf,''tag'',''cancel'',''visible'',''off'');',...
   'parent',srtfig);
okbtn=uicontrol('style','pushbutton',...
   'string','OK',...
   'callback','set(gcbf,''tag'',''ok'',''visible'',''off'');',...
   'parent',srtfig);

% layouts
grd=xreggridlayout(srtfig,'correctalg','on',...
   'packstatus','off',...
   'dimension',[2 1],...
   'gapy',10,...
   'rowsizes',[20 -1],...
   'elements',{srtud.Hand.nsortf,srtud.Hand.sortlist});
frm1=xregframetitlelayout(srtfig,'center',grd,...
   'title','Standard sort settings',...
   'innerborder',[10 10 0 10]);
frm2=xregframetitlelayout(srtfig,'center',srtud.Hand.custedt,...
   'title','Custom sort expression',...
   'innerborder',[10 10 10 10],...
   'enable','off');
grd2=xreggridlayout(srtfig,'correctalg','on',...
   'dimension',[1 1],...
   'rowsizes',[90],...
   'elements',{srtud.Hand.rbg});
frm3=xregframetitlelayout(srtfig,'center',grd2,...
   'title','Sort options',...
   'innerborder',[10 10 10 10]);

mainlyt=xreggridbaglayout(srtfig,...
   'dimension',[5 4],...
   'rowsizes',[-1 7 46 10 25],...
   'colsizes',[115 -1 65 65],...
   'gapx',7,...
   'mergeblock',{[1 3],[1 1]},...
   'mergeblock',{[1 1],[2 4]},...
   'mergeblock',{[3 3],[2 4]},...
   'elements',{frm3,[],[],[],[],...
      frm1,[],frm2,[],[],...
      [],[],[],[],okbtn,...
      [],[],[],[],cancbtn},...
   'border',[10 10 10 10]);

srtud.normalstate='on';
srtud.customstate='off';
srtud.normal=frm1;
srtud.custom=frm2;
srtud.nsort=numc;
srtud.ncols=numc;

srtfig.LayoutManager=mainlyt;
set(mainlyt,'packstatus','on');
srtfig.Userdata = srtud;
srtfig.showDialog(okbtn);

% block while user navigates gui
tg=get(srtfig,'tag');
switch lower(tg)
case 'cancel'
   ok=0;
   inds=[1:size(data,1)];
case 'ok'
   ok=1;
   [data,inds]=i_sortdata(srtfig,data);
end
delete(srtfig);
return



function i_radiosel(src,evt)
figh=src.Parent;
ud=get(figh,'userdata');
selnum=src.Selected;
sc=xregGui.SystemColorsDbl;
if selnum==4
   % disable both options
   norm='off';
   cust='off';
   custcol=sc.CTRL_BACK;
   tblcol= sc.CTRL_BACK;
elseif selnum==3
   % custom on
   norm='off';
   cust='on';
   custcol=[1 1 1];
   tblcol= sc.CTRL_BACK;
else
   % normal on
   norm='on';
   cust='off';
   custcol=sc.CTRL_BACK;
   tblcol= [1 1 1];
end
if ~strcmp(cust,ud.customstate)
   set(ud.custom,'enable',cust,'backgroundcolor',custcol);
   ud.customstate=cust;
end
if ~strcmp(norm,ud.normalstate)
   set(ud.normal,'enable',norm);
   if strcmp(norm,'on');
      % set the number of sort columns
      if ud.nsort<ud.ncols
         set(ud.Hand.sortlist,'cells.rowselection',[1 2],...
            'cells.colselection',[ud.nsort+1 ud.ncols],...
            'cells.enable','off',...
            'cells.rowselection',[2 2],...
            'cells.backgroundcolor',sc.CTRL_BACK,...
            'cells.colselection',[1 ud.nsort],...
            'cells.backgroundcolor',[1 1 1]);
      else
         ud.Hand.sortlist(2,:).backgroundcolor=[1 1 1];
      end
   else
      ud.Hand.sortlist(2,:).backgroundcolor=sc.CTRL_BACK;
   end
   ud.normalstate=norm;
end
set(figh,'userdata',ud);
return



function i_nsort(src,evt)
ud=get(src.Parent,'userdata');
nsrt=get(src,'value');
sc=xregGui.SystemColorsDbl;
if nsrt<ud.nsort
   set(ud.Hand.sortlist,'cells.rowselection',[1 2],...
      'cells.colselection',[nsrt+1 ud.nsort],...
      'cells.enable','off',...
      'cells.rowselection',[2 2],...
      'cells.backgroundcolor',sc.CTRL_BACK);
   ud.nsort = nsrt;
elseif nsrt>ud.nsort
   set(ud.Hand.sortlist,'cells.rowselection',[1 2],...
      'cells.colselection',[ud.nsort+1 nsrt],...
      'cells.enable','on',...
      'cells.rowselection',[2 2],...
      'cells.backgroundcolor',[1 1 1]);
      ud.nsort = nsrt;
else
   return
end
set(src.Parent,'userdata',ud);
return



function i_swapsel(src,evt)
figh=get(src,'parent');
ud=get(figh,'userdata');
r=evt.Row;
c=evt.Column;

valnow=ud.Hand.sortlist(2,:).value;
valch=valnow(c);
newval=find(~ismember(1:ud.ncols,valnow));
newcol=find(valnow==valch);
newcol=newcol(newcol~=c);
ud.Hand.sortlist(2,newcol).value=newval;
return



function [data,inds]=i_sortdata(figh,data)
ud=get(figh,'userdata');

% find out which option has been selected from rdbuttons
option=get(ud.Hand.rbg,'selected');

if option==1 | option==2
   % sort ascending/descending
   listtbl=ud.Hand.sortlist;
   sortvec=listtbl(2,1:ud.nsort).value;
   [data inds]=sortrows(data,sortvec);
   if option==2
      % sort descending
      % Just need to invert xmat
      data=data(end:-1:1,:);
      inds=inds(end:-1:1);
   end
   
elseif option==4
   % randomise
   % Need to know how many rows to randomise
   inds=randperm(size(data,1))';
   data=data(inds,:);
   
elseif option==3
   % need to evaluate custom expression
   % first create vector variables with the correct names
   varlist=ud.Hand.sortlist(2,1).string;
   expstr=get(ud.Hand.custedt,'string');
   if isempty(expstr)
      inds=(1:size(data,1))';
      return
   end
   g=vectorize(inline(expstr,varlist{:}));
   try
      data_cell=num2cell(data,1);
      expval=g(data_cell{:});
      [y,inds]=sort(expval);
      data=data(inds,:);
   catch
      h=errordlg(['An error was encountered while evaluating the sort expression.' char(10)...
            'Check that you have used correct variable names and valid MATLAB functions.' char(10)...
            'The input data has not been sorted.'],...
         'Error evaluating sort expression','modal');
      waitfor(h);
      inds=(1:size(data,1))';
   end
end