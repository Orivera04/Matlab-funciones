function newobj=copyobj(obj,fig)
%COPYOBJ Create a copy of an object in a new figure
%
%  NEWOBJ=COPYOBJ(OBJ,FIG) creates a replica of the object
%  OBJ in the figure FIG.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:19:01 $


% copy data structure
newobj=obj;

% copy graphics objects
fa=getaxes(xregGui.figureaxes,fig);
newobj.patch=double(copyobj(handle(obj.patch),getbgaxes(xregGui.figureaxes,fig)));
newobj.badim=double(copyobj(handle(obj.badim),fa));
newobj.axes=double(copyobj(handle(obj.axes),fig));
newobj.colorbar.axes=double(copyobj(handle(obj.colorbar.axes),fig));
newobj.xtext=double(copyobj(handle(obj.xtext),fig));
newobj.xfactor=double(copyobj(handle(obj.xfactor),fig));
newobj.ytext=double(copyobj(handle(obj.ytext),fig));
newobj.yfactor=double(copyobj(handle(obj.yfactor),fig));

newobj.line=findobj(newobj.axes,'type','line');
newobj.image=findobj(newobj.axes,'type','image');
datatags = findobj(newobj.axes, 'type', 'text', 'tag', 'graph2d_data_tag');
newobj.colorbar.bar=get(newobj.colorbar.axes,'children');

% create new layout structure for uicontrols
newobj.controls=xreggridbaglayout(fig,'packgroup','XX_MVGRAPH2D','dimension',[5,7],...
    'rowsizes',[-1 2 15 3 -1],'colsizes',[-1 70 -1 -1 70 -1 -1],'colratios',[1 1 3 2 1 3 1],...
    'mergeblock',{[2 4],[3 3]},'mergeblock',{[2 4], [6 6]},...
    'elements',{[],[],[],[],[],[],[];...
        [],[],newobj.xfactor,[],[],newobj.yfactor,[];...
        [],newobj.xtext,[],[],newobj.ytext,[],[];...
        [],[],[],[],[],[],[];...
        [],[],[],[],[],[],[]},...
    'position',get(obj.controls,'position'),...
    'packstatus','on');

% copy data
newobj.DataPointer = xregGui.RunTimePointer(obj.DataPointer.info);
newobj.DataPointer.LinkToObject(newobj.axes)
newobj.DataPointer.info.datataghandles = datatags;

cb = get(obj.xfactor, 'callback');
set([newobj.xfactor;newobj.yfactor],'callback',{cb{1}, newobj});
cb = get(obj.image, 'buttondownfcn');
set(newobj.image,'buttondownfcn',{cb{1}, newobj});
cb = get(obj.colorbar.bar, 'buttondownfcn');
set(newobj.colorbar.bar,'buttondownfcn',{cb{1}, newobj});
return