function fmtstr=tbl_formatgui(tbl,varargin)
%TABLE/TBL_FORMATGUI   Cell format changing GUI for tables
%   FMTSTR=TBL_FORMATGUI(TBL)  opens a GUI window prompting
%   the user to change the format string in the table TBL
%   The optional ouput returns the format string chosen, or 0
%   if Cancel is pressed

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:33:54 $



if nargin==1
   action='create';
else
   action=varargin{1};
end

switch lower(action)
case 'create'
   fmtstr=i_createfig(tbl);
   
case 'entrycheck'
   % check new entry in cell is numeric and ok.
   obj=gcbo;
   str=get(obj,'string');
   num=str2num(str);
   
   if isempty(num) | length(num(:))>1 | ~isnumeric(num)
      % put a nul entry in object
      set(obj,'string','0');
   end
case 'adventrycheck'
   % check entry in advanced cell is valid
   obj=gcbo;
   str=get(obj,'string');
   % attempt a dummy sprintf to check format string
   
   [nl, err]=sprintf(str,0);
   if ~isempty(err)
      set(obj,'string','%5.3f');
   end
   
case 'ok'  
   i_applyformatstring(varargin{2});
   set(varargin{2},'tag','ok'); 
case 'apply'
   i_applyformatstring(varargin{2});
case 'cancel'
   set(varargin{2},'tag','cancel');
end


function fmtstr= i_createfig(tbl)
% create figure window for altering precision
mnm=mfilename;
[pth,mnm,ext,ver]=fileparts(mnm);

scrsz=get(0,'screensize');
figh=figure('visible','off',...
   'position',[scrsz(3)/2-150 scrsz(4)/2-80 280 160],...
   'toolbar','none',...
   'menubar','none',...
   'numbertitle','off',...
   'name','Table Cell Format',...
   'units','pixels',...
   'resize', 'off',...
   'doublebuffer','on',...
   'color',get(0,'defaultuicontrolbackgroundcolor'));

[lyt,objh]=i_createlyt(figh,tbl);

% Add ok and cancel buttons

cbstr=[mnm '(get(' sprintf('%20.15f',objh) ',''userdata''),'];
cancbtn=uicontrol('style','pushbutton',...
   'position',[0 0 65 25],...
   'string','Cancel',...
   'callback',[cbstr '''cancel'',gcbf);']);
okbtn=uicontrol('style','pushbutton',...
   'position',[0 0 65 25],...
   'string','OK',...
   'callback',[cbstr '''ok'',gcbf);']);
applybtn=uicontrol('style','pushbutton',...
   'position',[0 0 65 25],...
   'string','Apply',...
   'callback',[cbstr '''apply'',gcbf);']);

flw1=xregflowlayout(figh,'packstatus','off','orientation','right/center',...
   'elements',{applybtn,cancbtn,okbtn},'gap',7,'border',[0 0 -7 0]);
main=xregborderlayout(figh,'center',lyt,'south',flw1,'innerborder',[10 45 10 10],...
   'container',figh,'packstatus','on');



set(figh,'closerequestfcn',[cbstr '''cancel'',gcbf);'],'visible','on');
drawnow;
set(figh,'windowstyle','modal');
waitfor(figh,'tag');

tg=get(figh,'tag');
switch lower(tg)
case 'ok'
   fmtstr=i_getformatstring(figh);
case 'cancel'
   fmtstr=0;
end
delete(figh);
return





function [lyt,objh]=i_createlyt(figh,tbl)

% Add frame with basic option fields


bs(1)=uicontrol('Style','text',...
   'position',[0 0 90 15],...
   'string','Total field width:',...
   'horizontalalignment','right',...
   'visible','off',...
   'userdata',tbl);
bs(2)=uicontrol('Style','text',...
   'position',[0 0 90 15],...
   'string','Significant figures:',...
   'horizontalalignment','right',...
   'visible','off');

mnm=mfilename;
[pth,mnm,ext,ver]=fileparts(mnm);
objh=bs(1);
objht=sprintf('%20.15f',objh);
cbstr=[mnm '(get(' objht ',''userdata''),'];

% work out current settings
str=get(tbl,'defaultcellformat');
dotpoint=findstr('.',str);

cl{1}=xregGui.clickedit(figh,'min',1,...
   'position',[0 0 45 20],...
   'visible','off',...
   'value',sscanf(str(2:dotpoint-1),'%d'),...
   'rule','int',...
   'clickincrement',1,...
   'dragincrement',1);
cl{2}=xregGui.clickedit(figh,'min',0,...
   'position',[0 0 45 20],...
   'visible','off',...
   'value',sscanf(str(dotpoint+1:end-1),'%d'),...
   'rule','int',...
   'clickincrement',1,...
   'dragincrement',1);




% add advanced options

ad(1)=uicontrol('style','text',...
   'position',[0 0 140 30],...
   'visible','off',...
   'string',['Enter a c-style format string:' sprintf('\n') ' (e.g. ''%5.3f'')'],...
   'horizontalalignment','left');
ad(2)=uicontrol('style','edit',...
   'position',[0 0 65 20],...
   'visible','off',...
   'string',str,...
   'backgroundcolor',[1 1 1],...
   'callback',[cbstr '''adventrycheck'',gcbf)']);

flw1=xregflowlayout(figh,'packstatus','off','orientation','left/center',...
   'elements',{bs(1), cl{1}},'gap',5);
flw2=xregflowlayout(figh,'orientation','left/center',...
   'elements',{bs(2), cl{2}},'gap',5);
tb1=xreggridlayout(figh,'correctalg','on','dimension',[3 1],'rowsizes',[30 30 -1],...
   'elements',{flw1, flw2, []});

flw1=xregflowlayout(figh,'orientation','left/center','elements',{ad(1),ad(2)},'gap',5);
tb2=xreggridlayout(figh,'correctalg','on','dimension',[2 1],'rowsizes',[40 -1],...
   'elements',{flw1,[]});
lyt=xregtablayout2(figh,'numcards',2,'labels',{'Basic','Advanced'},'innerborder',[10 10 10 10]);
attach(lyt,tb1,1);
attach(lyt,tb2,2);


ud.basic=bs;
ud.advanced=ad;
ud.clickedits=cl;
ud.table=tbl;
ud.tabs=lyt;
set(figh,'userdata',ud);

% decide whether advanced or basic view is more appropriate.
if ~strcmp(str(end),'f');
   set(ud.tabs,'currentcard',2);
end

return



function fmt=i_getformatstring(figh)
ud=get(figh,'userdata');
cl=ud.clickedits;
switch get(ud.tabs,'currentcard')
case 1
   % Basic option selected
   % need to get field width and decimal places and construct format string
   field=get(cl{1},'value');
   dec=get(cl{2},'value');
   fmt=['%' sprintf('%d',field) '.' sprintf('%d',dec) 'f'];
case 2
   % Placeholder for advanced
   fmt=get(ud.advanced(2),'string');
end
return



function i_applyformatstring(figh)
ud=get(figh,'userdata');
tbl=ud.table;
fmt=i_getformatstring(figh);

% try to apply format string
try
   % Alter table
   set(tbl,'defaultcellformat',fmt);
   % need to call subsasgn directly because we're within the table object
   s.type='()';
   s(2).type='.';
   s(1).subs={':',':'};
   s(2).subs='format';
   subsasgn(tbl,s,fmt);
catch
   %Must be an invalid format
   errordlg('The format string you entered is not recognised by the table.  Please re-enter it.','Invalid format','modal');
   return
end
return
