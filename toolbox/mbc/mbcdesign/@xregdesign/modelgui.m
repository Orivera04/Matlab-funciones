function lyt=modelgui(des,action,figh,p,varargin)
% DES_LINEARMOD/MODELGUI   Model setting GUI creation
%   H=MODELGUI(D,'create',FIGH,P) creates a gui for creating
%   the model and design size in the figure FIGH, using the object in
%   pointer P.
%   The output H is a layout handle.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:07:10 $


switch lower(action)
case 'layout'
   lyt=i_createlyt(figh,p,varargin{:});
case 'updatemodel'
   i_updatemodel(figh,p);
case 'designchange'
   i_designchange(figh);
case 'finalise'
   lyt=i_finalise(figh);
end


return



function lyt=i_createlyt(figh,p,varargin)

if ~isa(figh,'xregcontainer')
   udptr=xregGui.RunTimePointer;
   ud.pointer=p;
   ud.figure=figh;
   
   ud.im=xregGui.axesimage('parent',figh,'visible','off','image',imread('private\design_init.png'));
   
   ud.desgen=gui_reset(p.info,'layout',figh,p);
   lyt=xreggridlayout(figh,'correctalg','on',...
      'dimension',[1 2],...
      'gapx',10,...
      'colsizes',[200 -1],...
      'elements',{ud.im,ud.desgen},...
      'packstatus','off',...
      'userdata',udptr);
   % no callbacks
   udptr.info=ud;
else
   lyt=figh;
   udptr=get(lyt,'userdata');
   ud=udptr.info;
   ud.pointer=p;
   des=p.info;
   l=gui_reset(p.info,'layout',ud.desgen,p);
   udptr.info=ud;
end
return



function i_designchange(udh)
ud=get(udh,'userdata');
i_donext(ud);
return


function msg=i_finalise(lyt)
udptr=get(lyt,'userdata');
ud=udptr.info;

% call finalise on gui_reset
ok=gui_reset(ud.pointer.info,'finalise',ud.desgen);

if ~ok
   msg=['Unable to initialize design.  Check that you have not over-constrained the candidate set',...
         ' or specified a candidate set with insufficient points to support the model.'];
else
   msg='';
end
return


