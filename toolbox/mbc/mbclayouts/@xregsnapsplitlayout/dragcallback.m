function dragcallback(obj,action,varargin)
% DRAGCALLBACK  Dynamic split callback 
%
%   DRAGCALLBACK(OBJ,'start',SRC)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 07:36:55 $


switch lower(action)
case 'start'
   i_init(obj,varargin{1});
end

return


function i_init(obj,src)
ud=get(obj.xregcontainer,'userdata');
figh=get(ud.rsbutton,'parent');

objud.manager=MotionManager(figh);
objud.manager.EnableTree=false;
objud.oldfcns=get(figh,'windowbuttonupfcn');
objud.initpos=get(ud.rsbutton,'position');
objud.stpos=get(figh,'currentpoint');
objud.src=src;
objud.ptrID=-1;

% limits
sz=get(obj,'innerposition');
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
   if ud.barstyle==0
      thinvect=[0 3 0 -6];
   else
      thinvect=[0 0 0 0];
   end
else
   objud.mind=sz(1)-objud.initpos(1)+minw(1);
   objud.maxd=sz(1)+sz(3)-objud.initpos(1)-objud.initpos(3)-minw(2);
   if ud.barstyle==0
      thinvect=[3 0 -6 0];
   else
      thinvect=[0 0 0 0];
   end
end
objud.initpos=objud.initpos+thinvect;
objud.or=ud.orientation;
% create dummy dragging object
objud.dragobj=uicontrol('style','text','parent',figh,...
   'position',objud.initpos,...
   'backgroundcolor',[.5 .5 .5],...
   'visible','on');
objud.figure=figh;

set(figh,'windowbuttonupfcn',{@i_terminate, objud.dragobj, obj});
objud.manager.MouseMoveFcn={@i_drag,objud.dragobj, obj};
set(objud.dragobj,'userdata',objud);
return




function i_drag(srcobj,evt,moveobj, obj)
% update dummy object position
objud=get(moveobj,'userdata');
cp=evt.CurrentPoint;
% work out delta
if objud.or
   delta=cp(2)-objud.stpos(2);
else
   delta=cp(1)-objud.stpos(1);
end
if ~objud.src
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
else
   % hold bar in position until cursor moves a little more, then go to normal dragging mode
   if abs(delta)>5
      % break lock
      objud.src=0;
      % set dragging pointer
      PR=xregGui.PointerRepository;
      if objud.or
         objud.ptrID=PR.stackSetPointer(objud.figure,'uddrag');
      else
         objud.ptrID=PR.stackSetPointer(objud.figure,'lrdrag');
      end
      set(moveobj,'userdata',objud);
      i_drag(srcobj,evt,moveobj,obj);
   end
end
return





function i_terminate(srcobj,evt,moveobj, obj)

% get position, delete drag object, resize pack
objud=get(moveobj,'userdata');
delete(moveobj);
objud.manager.MouseMoveFcn='';
figh=objud.figure;
cp=get(figh,'currentpoint');
ud=get(obj.xregcontainer,'userdata');
if ~objud.src
   if objud.or
      delta=cp(2)-objud.stpos(2);
   else
      delta=cp(1)-objud.stpos(1);
   end
   
   % limit delta
   delta=max([delta objud.mind]);
   delta=min([delta objud.maxd]);
   
   % resize packing
   sp=get(obj,'split');
   oldsp=sp;
   sz=get(obj,'innerposition');
   
   if ud.barstyle==0
      divwidth=10;
   else
      divwidth=4;
   end
   if objud.or
      sp(1)=sp(1)-delta./(sz(4)-divwidth);
      sp(2)=sp(2)+delta./(sz(4)-divwidth);
   else
      sp(1)=sp(1)+delta./(sz(3)-divwidth);
      sp(2)=sp(2)-delta./(sz(3)-divwidth);
   end
   
   if sp~=oldsp
      ps=get(obj,'boolpackstatus');
      set(obj,'packstatus','on','split',sp,'state','center');
      if ~ps
         set(obj,'packstatus','off');
      end
   end
else
   % decide where to snap to
   if objud.src==1 | objud.src==3
      % move to top or left
      if ud.state
         % move to center
         st='center';
      else
         % move to edge
         st='left';
      end
   else
      % move to bottom or right
      if ud.state
         % move to center
         st='center';
      else
         % move to edge
         st='right';
      end      
   end
   ps=get(obj,'boolpackstatus');
   set(obj,'packstatus','on','state',st);
   if ~ps
      set(obj,'packstatus','off');
   end
end
% undo everything
figh=get(ud.rsbutton,'parent');
set(figh,'windowbuttonupfcn',objud.oldfcns);
if (objud.ptrID>=0)
   PR=xregGui.PointerRepository;
   PR.stackRemovePointer(figh,objud.ptrID);
end
objud.manager.EnableTree=true;
objud.manager.doUpdate;
% fire callback
firecb(obj);
