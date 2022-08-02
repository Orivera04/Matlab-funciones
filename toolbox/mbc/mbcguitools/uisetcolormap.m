function [outmap,outints]=uisetcolormap(inmap,inints,action,varargin)
% UISETCOLORMAP   Interactive colourmap editing.
%   UISETCOLORMAP allows editing of a colormap and the breaks associated with it.
%
%  Usage:
%  [map]=uisetcolormap(inmap,inints)  returns the colormap from a gui initialised
%                                     with the colormap inmap and the intervals inints
%
%  [map,ints]=uisetcolormap(inmap,inints)  returns the new intervals also.
%
%
%  Specifying NaN for the inints parameter will cause the colormap gui to not have any
%  display of interval numbers.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:34:11 $



if nargin<3
   action='create';
end


switch lower(action)
case 'create'
   
   noints=0;
   
   if nargin<2
      inints=[];
   end
   
   if ~nargin
      inmap=[0 0 0];
      
   end
   
   if isempty(inmap)
      inmap=[0 0 0];
   end
   
   if ~isempty(inints) & all(isnan(inints));
      noints=1;
      inints=[];
   end
   [outmap,outints]=i_createfig(inmap,inints,noints);
case 'chcol'
   i_changecol(inmap);
case 'chnum'
   i_changenum(inmap);
case 'mapnm'
   i_cmapname(inmap);
case 'gradient'
   i_gradient(inmap);
case 'numints'
   i_cmapsize(inmap);
case 'showentries'
   i_showentries(inmap);
end
return




function [outmap,outints]=i_createfig(inmap,inints,noints)

% Create the gui
if length(inints)<(size(inmap,1)-1)
   if isempty(inints)
      inints=0;
   end
   inints(end+1:(size(inmap,1)-1))=inints(end);
else
   inints=inints(1:(size(inmap,1)-1));
end

scrsz=get(0,'screensize');
if ~noints
   ht=190;
else
   ht=170;
end

figh=figure('visible','off',...
   'position',[scrsz(3)/2-200 scrsz(4)/2-75 405 ht],...
   'toolbar','none',...
   'menubar','none',...
   'numbertitle','off',...
   'name','Colormap',...
   'units','pixels',...
   'doublebuffer','on',...
   'resize','off',...
   'closerequestfcn','set(gcbf,''tag'',''cancel'');',...
   'color',get(0,'defaultuicontrolbackgroundcolor'));
okbtn=uicontrol('parent',figh,...
   'style','pushbutton',...
   'string','OK',...
   'callback','set(gcbf,''tag'',''ok'');',...
   'interruptible','off',...
   'position',[0 0 65 25]);
cancbtn=uicontrol('parent',figh,...
   'style','pushbutton',...
   'string','Cancel',...
   'callback','set(gcbf,''tag'',''cancel'');',...
   'interruptible','off',...
   'position',[0 0 65 25]);

[lyt,udh]=i_createlyt(figh,inmap,inints,noints);


flw=xregflowlayout(figh,'gap',7,'orientation','right/center',...
   'border',[0 0 -7 0],'elements',{cancbtn,okbtn});
bl=xregborderlayout(figh,'center',lyt,'south',flw,'innerborder',[10 45 10 10],...
   'packstatus','on','container',figh);

set(figh,'visible','on');
drawnow;
set(figh,'windowstyle','modal');
waitfor(figh,'tag');

tg=get(figh,'tag');
switch tg
case 'ok'
   output=get(udh,'userdata');
   outmap=output.map;
   if nargout==2
      outints=output.ints;
   end
case 'cancel'
   outmap=0;
   if nargout==2
      outints=0;
   end   
end
delete(figh);
return



function [lyt,cmapnmtxt]=i_createlyt(figh,inmap,inints,noints)

% Text and controls for altering number of intervals
cmapnmtxt=uicontrol('style','text',...
   'parent',figh,...
   'position',[0 0 70 15],...
   'string','Colormap:',...
   'horizontalalignment','left');
cmapsztxt=uicontrol('style','text',...
   'parent',figh,...
   'position',[0 0 100 15],...
   'string','Colormap size:',...
   'horizontalalignment','left');

ud.numints=xregGui.clickedit(figh,'min',1,...
   'rule','int',...
   'dragincrement',1,...
   'clickincrement',1,...
   'position',[0 0 60 20],...
   'value',size(inmap,1));
ud.mapnm=uicontrol('style','popupmenu',...
   'parent',figh,...
   'position',[0 0 90 20],...
   'string',{'Custom';'autumn';'bone';'colorcube';'cool';'copper';'flag';'gray';'hot';'hsv';'jet';...
      'lines';'pink';'prism';'spring';'summer';'white';'winter'},...
   'backgroundcolor','w');
ud.gradient=uicontrol('style','pushbutton',...
   'parent',figh,...
   'position',[0 0 100 25],...
   'string','Create a Gradient');
ud.entrynums=uicontrol('style','checkbox',...
   'parent',figh,...
   'position',[0 0 120 20],...
   'string','Show entry numbers',...
   'value',0);


udh=sprintf('%20.15f',cmapnmtxt);


if ~noints
   tblht=70;
   tbl=xregtable(figh,'position',[20 100 360 tblht],...
      'frame.visible','off',...
      'frame.vborder',[0 0],...
      'frame.hborder',[0 0],...
      'rows.spacing',2,...
      'cols.spacing',-10,...
      'cols.size',40,...
      'cells.defaultbackgroundcolor',[1 1 1],...
      'defaultcellformat','%g');
   
   % note: a vectorized set is possible here instead of the loop,
   % but the table object will end up looping internally anyway.
   tbl.redrawmode='basic';
   set(tbl,'cells.rowselection',[1 1],'cells.colselection',[1 1],...
      'cells.type','uiedit',...
      'cells.enable','inactive',...
      'cells.value',-inf);
   
   for n=1:length(inints)
      % continue to add to table
      set(tbl,'cells.rowselection',[2 2],'cells.colselection',[2*n 2*n],...
         'cells.type','uitogglebutton',...
         'cells.backgroundcolor',inmap(n,:),...
         'cells.callback',[mfilename '(' udh  ',[],''chcol'');'],...
         'cells.rowselection',[1 1],'cells.colselection',[(2*n)+1 (2*n)+1],...
         'cells.type','uiedit',...
         'cells.value',inints(n),...
         'cells.callback',[mfilename '(' udh  ',[],''chnum'');']);      
   end
   if isempty(n)
      n=0;
   end
   
   % Finish off colourmap table
   
   set(tbl,'cells.rowselection',[2 2],'cells.colselection',[(2*n)+2 (2*n)+2],...
      'cells.type','uitogglebutton',...
      'cells.backgroundcolor',inmap(end,:),...
      'cells.callback',[mfilename '(' udh  ',[],''chcol'');']);
   set(tbl,'cells.rowselection',[1 1],'cells.colselection',[(2*n)+3 (2*n)+3],...
      'cells.type','uiedit',...
      'cells.enable','inactive',...
      'cells.value',inf);
   tbl.redraw;
   tbl.redrawmode='normal';
   
else
   tblht=45;
   tbl=xregtable(figh,'position',[20 100 360 tblht],...
      'frame.visible','off',...
      'rows.spacing',2,...
      'frame.hborder',[0 0],...
      'frame.vborder',[0 0],...
      'cols.spacing',0,...
      'cols.size',20);
   
   % table only contains smaller colour swatches
   tbl.redrawmode='basic';
   n=size(inmap,1);
   set(tbl,'cells.rowselection',[1 1],'cells.colselection',[1 n],...
      'cells.type','uitogglebutton',...
      'cells.backgroundcolor',inmap(n,:),...
      'cells.callback',[mfilename '(' udh  ',[],''chcol'');']);
   for n=1:size(inmap,1)
      set(tbl,'cells.rowselection',[1 1],'cells.colselection',[n n],...
         'cells.backgroundcolor',inmap(n,:));
   end
   tbl.redraw;
   tbl.redrawmode='normal';
end

ud.map=inmap;
ud.ints=inints;
ud.table=tbl;
ud.noints=noints;
ud.figure=figh;
ud.udh=udh;

% callbacks
set(ud.numints,'callback',[mfilename '(' udh  ',[],''numints'');']);
set(ud.mapnm,'callback',[mfilename '(' udh  ',[],''mapnm'');']);
set(ud.gradient,'callback',[mfilename '(' udh  ',[],''gradient'');']);
set(ud.entrynums,'callback',[mfilename '(' udh  ',[],''showentries'');']);

% layouts

flw1=xregflowlayout(figh,'packstatus','off','orientation','left/center',...
   'elements',{cmapnmtxt,ud.mapnm});
flw2=xregflowlayout(figh,'orientation','left/center',...
   'elements',{cmapsztxt,ud.numints});
flw3=xregflowlayout(figh,'orientation','right/center',...
   'elements',{ud.gradient});
flw4=xregflowlayout(figh,'orientation','right/center',...
   'elements',{ud.entrynums});
flw2=xreglayerlayout(figh,'elements',{flw2,flw3});
flw1=xreglayerlayout(figh,'elements',{flw1,flw4});
% surround table
frm=xregpanellayout(figh,'innerborder',[0 0 0 0],...
   'center',tbl);
lyt=xreggridlayout(figh,'correctalg','on','dimension',[3 1],...
   'gap',10,'rowsizes',[-1 -1 tblht],'elements',{flw1,flw2,frm});

% set(figh,'tag',udh);
set(cmapnmtxt,'userdata',ud);
return




function i_changecol(udh)
% Change the colour of an interval
ud=get(udh,'userdata');
obj=gcbo;
cud=get(obj,'userdata');

% decide which colour button has been clicked
tbl=ud.table;
[r,c]=scrollindex(tbl,cud.row,cud.col);

if ~ud.noints
   col=round(c/2);
else
   col=c;
end

newcol=uisetcolor(ud.map(col,:));

ud.map(col,:)=newcol;
if ud.noints
   m=1;
else
   m=2;
end

tbl(m,c).backgroundcolor=newcol;
tbl(m,c).value=0;
if norm(newcol)<0.8
   fg=[1 1 1];
else
   fg=[0 0 0];
end
tbl(m,c).foregroundcolor=fg;

% set colourmap to custom
set(ud.mapnm,'value',1);

set(udh,'userdata',ud);
return



function i_changenum(udh)
% changes the interval number in userdata
ud=get(udh,'userdata');
obj=gcbo;
cud=get(obj,'userdata');

% decide which colour button has been clicked
tbl=ud.table;
[r,c]=scrollindex(tbl,cud.row,cud.col);
col=round((c-1)/2);


num=tbl(r,c).value;
% do basic check on number property
if (~isnumeric(num) | isempty(num) | length(num(:))>1)
   % pick up old value
   num=ud.ints(col);
end

% Check that num lies between any other intervals surrounding it
upnum=tbl(r,c+2).value;
downnum=tbl(r,c-2).value;
if num>upnum
   num=upnum;
end
if num<downnum
   num=downnum;
end
ud.ints(col)=num;
tbl(1,c).value=num;
set(udh,'userdata',ud);
return



function i_cmapname(udh)
ud=get(udh,'userdata');
val=get(ud.mapnm,'value');
if val==1
   return
end
set(ud.figure,'pointer','watch');

tbl=ud.table;

str=get(ud.mapnm,'string');
str=str{val};
sz=size(ud.map,1);
ud.map=feval(str,sz);

tbl.redrawmode='basic';
for n=1:(size(ud.map,1))
   if norm(ud.map(n,:))<0.8
      fg=[1 1 1];
   else
      fg=[0 0 0];
   end
   if ~ud.noints
      tbl(2,2*n).foregroundcolor=fg;
      tbl(2,2*n).backgroundcolor=ud.map(n,:);
   else
      tbl(1,n).foregroundcolor=fg;
      tbl(1,n).backgroundcolor=ud.map(n,:);
   end
end
tbl.redraw;
tbl.redrawmode='normal';
set(udh,'userdata',ud);
set(ud.figure,'pointer','arrow');
return




function i_cmapsize(udh)
% Set number of intervals to number typed by user
ud=get(udh,'userdata');
N=get(ud.numints,'value');
szold=size(ud.map,1);
if N==szold
   return
end
set(ud.figure,'pointer','watch');
% create new colourmap
% check for predefined one
val=get(ud.mapnm,'value');
if val>1
   str=get(ud.mapnm,'string');
   str=str{val};
   ud.map=feval(str,N);
else
   % custom
   if N>szold
      col=ud.map(end,:);
      ud.map((end+1):N,:)=repmat(col,N-szold,1);
   else
      ud.map=ud.map(1:N,:);
   end   
end

% sort interval vector if necessary
if ~ud.noints
   if N>szold
      if ~isempty(ud.ints)
         int=ud.ints(end);
         ud.ints(end+1:N-1)=int;
      else
         int=0;
         ud.ints(1:N-1)=0;
      end
   else
      ud.ints=ud.ints(1:N-1);
   end
end
donums=get(ud.entrynums,'value');
tbl=ud.table;
tbl.redrawmode='basic';
if N>szold
   if ~ud.noints
      % Add extra colors and new intervals
      tbl(2,((2*szold+2):2:(2*N))).type='uitogglebutton';
      tbl(2,((2*szold+2):2:(2*N))).callback=[mfilename '(' ud.udh ',[],''chcol'');'];
      for n=1:N
         tbl(2,2*n).backgroundcolor=ud.map(n,:);
      end
      tbl(1,((2*szold+1):2:((2*N)-1))).type='uiedit';
      tbl(1,((2*szold+1):2:((2*N)-1))).enable='on';
      tbl(1,((2*szold+1):2:((2*N)-1))).value=int;
      tbl(1,((2*szold+1):2:((2*N)-1))).backgroundcolor=[1 1 1];
      tbl(1,((2*szold+1):2:((2*N)-1))).callback=[mfilename '(' ud.udh ',[],''chnum'');'];
      
      set(tbl,'cells.rowselection',[1 1],'cells.colselection',[((2*N)+1) ((2*N)+1)],...
         'cells.type','uiedit',...
         'cells.backgroundcolor',[1 1 1],...
         'cells.enable','inactive',...
         'cells.string','inf',...
         'cells.callback',[mfilename '(' ud.udh ',[],''chnum'');']);
      if donums
         for n=szold+1:N
            if norm(ud.map(n,:))<0.8
               fg=[1 1 1];
            else
               fg=[0 0 0];
            end
            tbl(2,2*n).foregroundcolor=fg;   
            tbl(2,2*n).string=sprintf('%d',n);
         end
      end
   else
      % add extra colours
      tbl(1,((szold+1):N)).type='uitogglebutton';
      tbl(1,((szold+1):N)).callback=[mfilename '(' ud.udh ',[],''chcol'');'];
      for n=1:N
         tbl(1,n).backgroundcolor=ud.map(n,:);
      end
      if donums
         for n=szold+1:N
            if norm(ud.map(n,:))<0.8
               fg=[1 1 1];
            else
               fg=[0 0 0];
            end
            tbl(1,n).foregroundcolor=fg;   
            tbl(1,n).string=sprintf('%d',n);
         end
      end
   end
else
   if ~ud.noints
      tbl.cols.number=((2*N)+1);
      tbl(1,end).value=inf;
      tbl(1,end).enable='inactive';
   else
      tbl.cols.number=N;         
   end
   if val>1
      % redo colourmap
      if ~ud.noints
         for n=1:N
            tbl(2,2*n).backgroundcolor=ud.map(n,:);
         end
      else
         for n=1:N
            tbl(1,n).backgroundcolor=ud.map(n,:);
         end
      end
   end
end
tbl.redrawmode='normal';
tbl.redraw;
set(udh,'userdata',ud);
set(ud.figure,'pointer','arrow');
return




function i_gradient(udh)
ud=get(udh,'userdata');

set(ud.figure,'pointer','watch');
% Create a smooth colour gradient between the first and last selected colours

% First of all, only do it if there's more than two intervals
if size(ud.map,1)<3
   set(ud.figure,'pointer','arrow');
   return
end

stcol=ud.map(1,:);
endcol=ud.map(end,:);

RGBstep=(endcol-stcol)./(size(ud.map,1));

tbl=ud.table;
tbl.redrawmode='basic';
for n=2:(size(ud.map,1)-1)
   ud.map(n,:)=ud.map(n-1,:)+RGBstep;
   if norm(ud.map(n,:))<0.8
      fg=[1 1 1];
   else
      fg=[0 0 0];
   end
   if ~ud.noints
      tbl(2,2*n).backgroundcolor=ud.map(n,:);
      tbl(2,2*n).foregroundcolor=fg;
   else
      tbl(1,n).backgroundcolor=ud.map(n,:);
      tbl(1,n).foregroundcolor=fg;
   end
end
tbl.redraw;
tbl.redrawmode='normal';
set(udh,'userdata',ud);
set(ud.mapnm,'value',1);
set(ud.figure,'pointer','arrow');
return



function i_showentries(udh)
ud=get(udh,'userdata');
set(ud.figure,'pointer','watch');
val=get(ud.entrynums,'value');

if val
   if ud.noints
      
      for n=1:size(ud.map,1)
         if norm(ud.map(n,:))<0.8
            fg=[1 1 1];
         else
            fg=[0 0 0];
         end
         ud.table(1,n).foregroundcolor=fg;   
         ud.table(1,n).string=sprintf('%d',n);
      end
   else
      for n=1:size(ud.map,1)
         if norm(ud.map(n,:))<0.8
            fg=[1 1 1];
         else
            fg=[0 0 0];
         end
         ud.table(2,2*n).foregroundcolor=fg;   
         ud.table(2,2*n).string=sprintf('%d',n);
      end
   end
else
   if ud.noints
      ud.table(1,:).string='';
   else
      ud.table(2,2:2:end).string='';
   end
end
set(ud.figure,'pointer','arrow');
return




