function cellcb(hnd, action)
%TABLE/CELLCB   Callback function
%   CELLCB is installed on all uicontrols in a table to handle
%   value changes and pass them down into the underlying matrix
%   or reject them as inappropriate

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:32:27 $


if nargin<2
   action='normal';
end

persistent fe fb DOINGUPDATE

switch action
case 'normal'
   [cellh,cud,fhandle,fud,x,y]=i_initdata;
   switch fud.cells.ctype(x,y)  
   case {1,2,3}
      fud=i_doedits(hnd,fud,cellh,x,y);
   case {4,5,6,7,8,9,10,11}
      fud.cells.value(x,y)=get(cellh,'Value');
   case 0
      if ~isnan(fud.cells.value(x,y))
         num=str2num(get(cellh,'String'));
         [out err]=sprintf(hnd,fud.cells.format{x,y},num);
         if isempty(err)
            fud.cells.value(x,y)=num;
            set(cellh,'string',out);
         else
            set(cellh,'string',sprintf(hnd,fud.cells.format{x,y},fud.cells.value(x,y)));
         end 
      end   
   case 12
      set(cellh,'value',0);
      
   case 13
      set(cellh,'value',1);
      
   case 14
      % lets get clever
      fH=get(cellh,'parent');
      % inactivate figure objects, hook into figure windowbuttondownfcn
      cud.uicontch=findobj(get(fH,'children'),'flat','type','uicontrol','enable','on');
      cud.uiconthitch=findobj(get(fH,'children'),'flat','type','uicontrol','enable','inactive');
      cud.uiconthitch=[cud.uiconthitch;findobj(get(fH,'children'),'flat','type','uicontrol','enable','off')];
      cud.uimenuch=findobj(get(fH,'children'),'flat','type','uimenu','enable','on');
      cud.uitoolch=get(findobj(get(fH,'children'),'flat','type','uitoolbar'),'children');
      cud.fig=fH;
      cud.windowdownfcn=get(fH,'windowbuttondownfcn');
      cud.resizefcn=get(fH,'resizefcn');
      cud.cellh=cellh;
      cud.uitoolens=get(cud.uitoolch,'enable');
      cud.uiconthit=get(cud.uiconthitch,'hittest');
      if ~iscell(cud.uiconthit)
         cud.uiconthit={cud.uiconthit};
      end      
      set(cud.uimenuch,'enable','off');
      set(cud.uitoolch,'enable','off');
      set(cud.uicontch,'enable','inactive');
      set(cud.uiconthitch,'hittest','off');
      
      obj_cb=get(cellh,'callback');
      
      % analyse for additional string stuff
      sempos=findstr(obj_cb,';');
      if sempos(1)<length(obj_cb);
         cud.callback=obj_cb(sempos(1)+1:end);
      else
         cud.callback='';
      end
         
      fb=uicontrol('style','pushbutton','enable','off','position',get(cellh,'position')+[-3 -3 6 6]);
      fe=uicontrol('style','edit',...
         'callback',sprintf('cellcb(get(%20.15f,''userdata''),''tempeditcomplete'');',fud.objecthandle),...
         'visible','on','position',get(cellh,'position'),'userdata',cud,'string',get(cellh,'string'),...
         'backgroundcolor',get(cellh,'backgroundcolor'),'foregroundcolor',get(cellh,'foregroundcolor'),...
         'interruptible','off','tag','waiting','horizontalalignment',get(cellh,'horizontalalignment'));
      set(fH,'windowbuttondownfcn',sprintf('cellcb(get(%20.15f,''userdata''),''tempeditcomplete'');',fud.objecthandle),...
         'resizefcn',sprintf('cellcb(get(%20.15f,''userdata''),''resizecancel'');',fud.objecthandle));
      DOINGUPDATE=0;
   end
   set(fhandle,'Userdata',fud);
   
   % send callback
   if fud.cells.ctype(x,y)~=14
      i_firecb(hnd,cud,fud);
   end
   
   
case 'tempeditcomplete'
   % check whether this is a callback or originates from a window click
   cb_obj=gcbo;
   if ~isempty(cb_obj) & cb_obj~=fe
      % give potential callbacks a chance to overtake us
      FROMCB=0;
      drawnow;
   else
      FROMCB=1;
   end
   
   if ishandle(fe) & ~DOINGUPDATE
      DOINGUPDATE=1;
      cud=get(fe,'userdata');
      set(cud.cellh,'value',1);
      set([fe;fb],'visible','off');
      i_cleanupfig(cud);
      
      if FROMCB
         [cellh,cud,fhandle,fud,x,y]=i_initdata(fe);
         set(cud.cellh,'string',get(fe,'string'));
         fud=i_doedits(hnd,fud,cud.cellh,x,y);
         set(cud.parent,'userdata',fud);
         % execute additional callbacks
         if ~isempty(cud.callback)
            evalin('base',cud.callback);
         end
         i_firecb(hnd,cud,fud);
      end
      delete([fe,fb]);
      DOINGUPDATE=0;
   end
   
case 'tempeditoff'
   if ishandle(fe) & ~DOINGUPDATE
      cud=get(fe,'userdata');
      i_cleanupfig(cud);
      set(cud.cellh,'value',1);
      set([fe;fb],'visible','off');
      delete([fe,fb]);
   end
   
case 'resizecancel'
   % this call originates from a figure being resized while editing is in progress
   if ishandle(fe)
      try
         cud=get(fe,'userdata');
         set(cud.cellh,'value',1);
         set([fe;fb],'visible','off');
         delete([fe;fb]);
         i_cleanupfig(cud); 
         if ~isempty(cud.resizefcn)
            xregcallback(cud.resizefcn,get(fe,'parent'),[]);
         end
      catch
         % this normally means the resizefcn needs to be executed from the figure
         xregcallback(get(get(hnd.hslider.handle,'parent'),'resizefcn'),get(hnd.hslider.handle,'parent'),[]);
      end
   end
end
return




function i_cleanupfig(cud);
set(cud.uicontch,'enable','on');
set(cud.uimenuch,'enable','on');
set(cud.uitoolch,{'enable'},cud.uitoolens);
set(cud.uiconthitch,{'hittest'},cud.uiconthit);

set(cud.fig,'windowbuttondownfcn',cud.windowdownfcn,...
   'resizefcn',cud.resizefcn);
return



function [cellh,cud,fhandle,fud,x,y]=i_initdata(cellh);

if ~nargin
   cellh=gcbo;
end
cud=get(cellh,'userdata');
fhandle=cud.parent;
fud=get(fhandle,'Userdata');
% first need to know if it is a fixed cell or scroll cell, for indexing
if strcmp(cud.type,'fixed')
   x=cud.row;
   y=cud.col;
elseif strcmp(cud.type,'scroll')
   sldata=get([fud.hslider.handle;fud.vslider.handle],{'Userdata','Value'});
   hslud=sldata{1,1};
   vslud=sldata{2,1};
   hslval=round(sldata{1,2});
   vslval=round(abs(sldata{2,2}));
   x=cud.row+vslud.steps(vslval,1)-1;
   y=cud.col+hslud.steps(hslval,1)-1;
end
return



function fud=i_doedits(hnd,fud,cellh,x,y)
if ~isnan(fud.cells.value(x,y))
   % assume we're trying to enter a value
   num=str2num(get(cellh,'String'));
   [out err]=sprintf(hnd,fud.cells.format{x,y},num);
   if isempty(err)
      fud.cells.value(x,y)=num;
      set(cellh,'string',out);
      % Alter string color if usecolors is on
      if strcmp(fud.usecolors,'on')
         cmap=fud.colormap;
         cint=fud.colorintervals;
         
         % Make sure map is one longer than the intervals
         if length(cint)+1<size(cmap,1)
            cmap=cmap(1:(length(cint)+1),:);
         else
            cint=cint(1:(size(cmap,1)-1));
         end
         
         % determine which interval it's in
         intv=min(find((num<cint)));
         if isempty(intv)
            % means that the value is over the end of the given interval vector, ie last color
            intv=length(cint)+1;
         end
         
         % set colour
         set(cellh,'Foregroundcolor',cmap(intv,:));
      end
      
   else
      set(cellh,'string',sprintf(fud.cells.format{x,y},fud.cells.value(x,y)));
   end 
else
   % accept a string input
   fud.cells.string(x,y)={get(cellh,'String')};
end   
return




function i_firecb(h,cud,fud)
if ~isempty(fud.cellchangecb)
   [r,c]=scrollindex(h,cud.row,cud.col);
   evt.Row=r;
   evt.Column=c;
   xregcallback(fud.cellchangecb,h,evt);
end
