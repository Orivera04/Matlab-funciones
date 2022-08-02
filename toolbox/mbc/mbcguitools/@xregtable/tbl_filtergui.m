function filt=tbl_filtergui(tbl,varargin)
%TABLE/TBL_FILTERGUI   Filter changing GUI for a table object
%   FILT=TBL_FILTERGUI(TBL)
%   GUI table method which pops up a modal dialogue to handle
%   changing the filter on the given table.  The optional output
%   returns the filter type and settings in a structure

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:33:53 $


if nargin==1
   action='create';
else
   action=varargin{1};
end


switch lower(action)
case 'create'
   filt=i_createfig(tbl);
   
case 'apply'
   % apply, don't close
   i_applyfilt(varargin{2});
   
case 'ok'
   % Set up filter properties and close filter dialog
   figh=varargin{2};
   i_applyfilt(figh);
   set(figh,'tag','ok');
   
case 'remove'
   % Set table filter to none and close filter dialog
   figh=varargin{2};
   ud=get(figh,'userdata');
   tbl=ud.table;
   set(tbl,'filters.type','none');
   ud.filttype='none';
   set(figh,'userdata',ud);
   set(figh,'tag','ok');
   
case 'swaptype'
   % Need to enable/disable tolerance appropriately.
   ud=get(varargin{2},'userdata');
   val=get(ud.advanced(3),'value');
   switch val
   case {1,2}
      % enable tolerance
      set([ud.advanced(5);ud.advanced(6)],'enable','on');
   otherwise
      set([ud.advanced(5);ud.advanced(6)],'enable','off');
   end
   
case 'entrycheck'
   % check new entry in cell is numeric and ok.
   obj=gcbo;
   str=get(obj,'string');
   num=str2double(str);
   
   if isnan(num)
      % put a nul entry in object
      set(obj,'string','0');
   end
case 'cancel'
   % just quit gui
   set(varargin{2},'tag','cancel');
end


function filt=i_createfig(tbl)
% create figure window for altering precision
scrsz=get(0,'screensize');
figh=figure('visible','off',...
   'position',[scrsz(3)/2-150 scrsz(4)/2-120 350 240],...
   'toolbar','none',...
   'menubar','none',...
   'numbertitle','off',...
   'name','Table Filters',...
   'units','pixels',...
   'resize','off',...
   'doublebuffer','on',...
   'color',get(0,'defaultuicontrolbackgroundcolor'));

[lyt, objh]=i_createlyt(figh,tbl);

mnm=mfilename;
[pth,mnm,ext,ver]=fileparts(mnm);
cbstr=[mnm '(get(' sprintf('%20.15f',objh) ',''userdata'')'];

% Add ok, cancel, apply and a remove filter buttons
cancbtn=uicontrol(figh,'style','pushbutton',...
   'position',[0 0 65 25],...
   'string','Cancel',...
   'callback',[cbstr ',''cancel'',gcbf)']);
okbtn=uicontrol(figh,'style','pushbutton',...
   'position',[0 0 65 25],...
   'string','OK',...
   'callback',[cbstr ',''ok'',gcbf);']);
applybtn=uicontrol(figh,'style','pushbutton',...
   'position',[0 0 65 25],...
   'string','Apply',...
   'callback',[cbstr ',''apply'',gcbf);']);
rembtn=uicontrol(figh,'style','pushbutton',...
   'position',[0 0 90 25],...
   'string','Remove Filter',...
   'callback',[cbstr ',''remove'',gcbf);']);


oklyt = xregflowlayout(figh,'orientation','right/center','elements',{applybtn,cancbtn,okbtn},...
   'gap',7,'border',[0 0 -7 0],'packstatus','off');
remlyt = xregflowlayout(figh,'orientation','left/center','elements',{rembtn});
btns = xreglayerlayout(figh,'elements',{remlyt,oklyt});
main = xregborderlayout(figh,'center',lyt,'south',btns,'innerborder',[10 45 10 10],...
   'container',figh,'packstatus','on');

set(figh,'closerequestfcn',[cbstr ',''cancel'',gcbf)'],'visible','on');
drawnow;
set(figh,'windowstyle','modal');
waitfor(figh,'tag');

% get output
tg=get(figh,'tag');
switch lower(tg)
case 'ok'
   filt=i_getfiltvals(figh);
case 'cancel'
   filt=0;
end

delete(figh);
return




function [lyt,objh]=i_createlyt(figh,tbl)

% Add basic/advanced options.  the opts object holds a copy of the table
% for forcing access to this table method in the callbacks
mnm=mfilename;
[pth,mnm,ext,ver]=fileparts(mnm);

% text fields describing the opptions
bs(1)=uicontrol(figh,'style','text',...
   'string',['The "Basic" option will construct a filter which prevents cells',...
      ' in the table which are equal to the specified value, within the specified',...
      ' tolerance, from being displayed.'],...
   'horizontalalignment','left',...
   'visible','off',...
   'userdata',tbl);
ad(1)=uicontrol(figh,'style','text',...
   'string',['The "Advanced" option will construct a filter using the settings',...
      ' below.  Cells which test true by the filter will not have their values',...
      ' displayed.'],...
   'horizontalalignment','left',...
   'visible','off');
div1=xregGui.dividerline(figh,'visible','off');
div2=xregGui.dividerline(figh,'visible','off');


objh=sprintf('%20.15f',bs(1));
cbstr=[mnm '(get(' objh ',''userdata''),'];

% basic options
bs(2)=uicontrol(figh,'Style','text',...
   'position',[0 0 100 15],...
   'string','Value to filter out:',...
   'horizontalalignment','right',...
   'visible','off');
bs(3)=uicontrol(figh,'Style','text',...
   'position',[0 0 100 15],...
   'string','Tolerance level:',...
   'horizontalalignment','right',...
   'visible','off');
bs(4)=uicontrol(figh,'Style','edit',...
   'position',[0 0 60 20],...
   'string',num2str(get(tbl,'filters.value')),...
   'backgroundcolor',[1 1 1],...
   'callback',[cbstr '''entrycheck'',gcbf)'],...
   'visible','off');
bs(5)=uicontrol(figh,'Style','edit',...
   'position',[0 0 60 20],...
   'string',num2str(get(tbl,'filters.tolerance')),...
   'backgroundcolor',[1 1 1],...
   'callback',[cbstr '''entrycheck'',gcbf)'],...
   'visible','off');

% add advanced options

ad(2)=uicontrol(figh,'style','text',...
   'position',[0 0 85 15],...
   'visible','off',...
   'string','Exclude values:',...
   'horizontalalignment','center');
% Find initial value for popupmenu
cur_str=get(tbl,'filters.type');
switch cur_str
case {'eq','none'}
   popval=1;
case 'ne'
   popval=2;      
case 'lt'
   popval=3;
case 'le'
   popval=4;
case 'gt'
   popval=5;
case 'ge'
   popval=6;
end
ad(3)=uicontrol(figh,'style','popupmenu',...
   'position',[0 0 50 20],...
   'visible','off',...
   'string','==|~=|<|<=|>|>=',...
   'value',popval,...
   'backgroundcolor','w',...
   'callback',[cbstr '''swaptype'',gcbf);']);
ad(4)=uicontrol(figh,'style','edit',...
   'position',[0 0 60 20],...
   'visible','off',...
   'string',num2str(get(tbl,'filters.value')),...
   'backgroundcolor','w',...
   'callback',[cbstr '''entrycheck'',gcbf)'],...
   'horizontalalignment','left');

% Using char(177) may be a bit dodgy for the +/- sign.  I don't want to resort
% to an axis for TeX commands though
ad(5)=uicontrol(figh,'style','text',...
   'position',[0 0 8 16],...
   'string', char(177),...
   'horizontalalignment','left',...
   'visible','off');
ad(6)=uicontrol(figh,'style','edit',...
   'position',[0 0 60 20],...
   'visible','off',...
   'string',num2str(get(tbl,'filters.tolerance')),...
   'backgroundcolor','w',...
   'callback',[cbstr '''entrycheck'',gcbf)'],...
   'horizontalalignment','left');


% layouts
flw1=xregflowlayout(figh,'packstatus','off','orientation','left/center',...
   'elements',{bs(2),bs(4)},'gap',5);
flw2=xregflowlayout(figh,'orientation','left/center',...
   'elements',{bs(3),bs(5)},'gap',5);
grd=xreggridlayout(figh,'dimension',[3 1],'correctalg','on','rowsizes',[30 30 -1],...
   'elements',{flw1,flw2,[]});
tb1=xreggridlayout(figh,'dimension',[3 1],'correctalg','on','rowsizes',[45 20 -1],...
   'elements',{bs(1),div1,grd});

flw1=xregflowlayout(figh,'orientation','left/center',...
   'elements',{ad(2),ad(3),ad(4),ad(5),ad(6)},'gap',5);
grd=xreggridlayout(figh,'dimension',[3 1],'correctalg','on','rowsizes',[10 30 -1],...
   'elements',{[],flw1,[]});
tb2=xreggridlayout(figh,'dimension',[3 1],'correctalg','on','rowsizes',[45 20 -1],...
   'elements',{ad(1),div2,grd});
lyt=xregtablayout2(figh,'numcards',2,'labels',{'Basic','Advanced'},'innerborder',[15 10 10 10]);
attach(lyt,tb1,1);
attach(lyt,tb2,2);

ud.filttype='';
ud.advanced=ad;
ud.basic=bs;
ud.table=tbl;
ud.figure=figh;
ud.tabs=lyt;

set(figh,'userdata',ud);
objh=bs(1);
return




function i_applyfilt(figh)

ud=get(figh,'userdata');
tbl=ud.table;
switch(get(ud.tabs,'currentcard'))
case 1
   %Basic
   tp='eq';
   val=str2num(get(ud.basic(4),'string'));
   tol=str2num(get(ud.basic(5),'string'));
case 2
   %Advanced
   tpval=get(ud.advanced(3),'value');
   switch tpval
   case 1
      tp='eq';
   case 2
      tp='ne';
   case 3
      tp='lt';
   case 4
      tp='le';
   case 5
      tp='gt';
   case 6
      tp='ge';
   end
   val=str2num(get(ud.advanced(4),'string'));
   tol=str2num(get(ud.advanced(6),'string'));
end
ud.filttype=tp;
set(tbl,'filters.type',tp,'filters.value',val,'filters.tolerance',tol);
set(figh,'userdata',ud);
return





function filt=i_getfiltvals(figh)
ud=get(figh,'userdata');
filt.type=ud.filttype;
switch(get(ud.tabs,'currentcard'))
case 1
   %Basic
   filt.value=str2num(get(ud.basic(4),'string'));
   filt.tolerance=str2num(get(ud.basic(5),'string'));
case 2
   %Advanced
   filt.value=str2num(get(ud.advanced(4),'string'));
   filt.tolerance=str2num(get(ud.advanced(6),'string'));
end
return