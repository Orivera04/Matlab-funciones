function LYT=printcopy(obj,fig)
%PRINTCOPY  Create a printer-friendly copy of mvgraph1d
%
%  LYT=PRINTCOPY(OBJ,FIG)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:19:09 $

% copy main axes always
ax=copyobj(obj.axes,fig);
ax=axiswrapper(ax);

ud = obj.DataPointer.info;
switch ud.type
case {'graph','sparse'}
   % remove image object from axes
   h=findobj(get(ax,'children'),'type','image');
   delete(h); 
   LYT=xreglayerlayout(fig,'elements',{ax},...
      'border',[45 45 10 10]);  
case 'image'
   % remove line object from axes
   h=findobj(get(ax,'children'),'type','line');
   delete(h); 
   % remove buttondownfcn
   h=get(ax,'children');
   set(h,'buttondownfcn','');
   % add colorbar
   axcol=copyobj(obj.colorbar.axes,fig);
   set(axcol,'userdata',[]);
   set(get(axcol,'children'),'buttondownfcn','','userdata',[]);
   
   LYT=xreggridlayout(fig,'correctalg','on',...
      'dimension',[2 1],...
      'gapy',35,...
      'rowsizes',[-1 20],...
      'elements',{ax,axcol},...
      'border',[50 25 10 10]);
end