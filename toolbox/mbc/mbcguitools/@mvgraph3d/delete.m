function delete(gr)
%DELETE Deletes graph3d objects
%   DELETE(GR) deletes the graph object in gr.
%   Note that this deletes all the handle graphics objects
%   associated with GR, however MATLAB will still think GR
%   is a valid object.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.4.2 $  $Date: 2004/02/09 07:19:22 $

if ishandle(gr.axes) 
   mv_rotate3d(double(gr.axes),'off');
   fig=handle(gr.axes.parent);
   if ishandle(fig) & ~isBeingDestroyed(fig)
      delete([gr.axes;gr.surf;gr.colorbar.axes;gr.colorbar.bar; gr.badim;...
            gr.xfactor;gr.xtext;gr.yfactor;gr.ytext;gr.zfactor;gr.ztext;gr.patch]);
   end
end