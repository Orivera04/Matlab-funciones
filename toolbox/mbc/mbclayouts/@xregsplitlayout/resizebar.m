function resizebar(srcobj,evt,obj)
%RESIZEBAR   Divider bar resizing function for splitlayout
%
%   RESIZEBAR(SRCOBJ,EVT,OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:37:11 $


i_init(obj);

return


function i_init(obj)
ud=obj.datastore.info;
figh=get(obj,'parent');

objud.Manager=MotionManager(figh);
objud.Manager.EnableTree=false;

objud.oldfcns=get(figh,'windowbuttonupfcn');
objud.initpos=get(obj.rsbutton,'position');
objud.stpos=get(figh,'currentpoint');
%objud.ptr=get(figh,'pointer');
% limits
sz=get(obj,'position');
minw=ud.minwidth;
if strcmp(ud.minwidthunits,'normalized')
   if ud.orientation
      minw=minw.*sz(4);
   else
      minw=minw.*sz(3);
   end
end
if (ud.orientation)
   objud.mind=sz(2)-objud.initpos(2)+minw(2);
   objud.maxd=sz(2)+sz(4)-objud.initpos(2)-objud.initpos(4)-minw(1);
else
   objud.mind=sz(1)-objud.initpos(1)+minw(1);
   objud.maxd=sz(1)+sz(3)-objud.initpos(1)-objud.initpos(3)-minw(2);
end
objud.or=ud.orientation;
% create dummy dragging object
objud.dragobj=uicontrol('style','text','parent',figh,...
   'position',objud.initpos,...
   'backgroundcolor',[.6 .6 .6],...
   'visible','on');
objud.figure=figh;


set(figh,'windowbuttonupfcn',{@i_terminate, objud.dragobj, obj});
objud.Manager.MouseMoveFcn={@i_drag,objud.dragobj, obj};

set(obj.rsbutton,'value',1);
set(objud.dragobj,'userdata',objud);



function i_drag(srcobj,evt,moveobj, obj)
% update dummy object position
objud=get(moveobj,'userdata');
%cp=get(objud.figure,'currentpoint');
cp=evt.CurrentPoint;
% work out delta
if objud.or
   delta=cp(2)-objud.stpos(2);
else
   delta=cp(1)-objud.stpos(1);
end

% limit delta
delta=max([delta objud.mind]);
delta=min([delta objud.maxd]);

objpos=objud.initpos;
if objud.or
   objpos(2)=objpos(2)+delta;
else
   objpos(1)=objpos(1)+delta;
end

set(moveobj,'position',objpos);


function i_terminate(srcobj,evt,moveobj, obj)

% get position, delete drag object, resize pack
objud=get(moveobj,'userdata');
objud.Manager.MouseMoveFcn='';
figh=objud.figure;
set(figh,'windowbuttonupfcn',objud.oldfcns);

delete(moveobj);

cp=get(figh,'currentpoint');
if objud.or
   delta=cp(2)-objud.stpos(2);
else
   delta=cp(1)-objud.stpos(1);
end
if delta
   % limit delta
   delta=max([delta objud.mind]);
   delta=min([delta objud.maxd]);
   
   % resize packing
   sp=get(obj,'split');
   oldsp=sp;
   sz=get(obj,'position');
   
   ud=obj.datastore.info;
   if objud.or
      sp(1)=sp(1)-delta./(sz(4)-ud.divwidth);
      sp(2)=sp(2)+delta./(sz(4)-ud.divwidth);
   else
      sp(1)=sp(1)+delta./(sz(3)-ud.divwidth);
      sp(2)=sp(2)-delta./(sz(3)-ud.divwidth);
   end
   
   if sp~=oldsp
      ps=get(obj,'boolpackstatus');
      set(obj,'packstatus','on','split',sp);
      if ~ps
         set(obj,'boolpackstatus',false);
      end
   end
end

% undo everything
set(obj.rsbutton,'value',0);
objud.Manager.EnableTree=true;

% fire callback
if delta
   firecb(obj);
end
return

