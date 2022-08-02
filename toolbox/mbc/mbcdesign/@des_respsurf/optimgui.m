function lyt=optimgui(des,action,figh,p)
% DES_RESPSURF/OPTIMGUI   Optimisation algorithm GUI creation
%   H=OPTIMGUI(D,'create',FIGH,OBJH,POS) creates a gui for creating
%   the optimisation settings in the figure FIGH, using the object in
%   OBJH for callbacks and contained within the area POS.
%   The output H is a handle pointing to the userdata for the
%   gui.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:03:48 $


switch lower(action)
case 'layout'
   lyt=gui_optimcp(des,'layout',figh,p,...
      'startfcn',{@i_startopt,figh},...
      'stopfcn',{@i_stopopt,figh});
case 'finalise'
   lyt='';
end
return

function i_startopt(src,evt,figh)

ud=get(figh,'userdata');
set([ud.cancel;ud.back;ud.next;ud.finish],'enable','off');


function i_stopopt(src,evt,figh)
ud=get(figh,'userdata');
set([ud.cancel;ud.back;ud.finish],'enable','on');