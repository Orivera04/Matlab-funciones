function delete(gr)
%DELETE   Deletes graph4d HG objects
%   DELETE(GR) deletes the graph object in gr.
%   Note that this actually only deletes the HG
%   objects associated with GR.  MATLAB will still
%   treat GR as a valid object.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.4.2 $  $Date: 2004/02/09 07:19:42 $

if ishandle(gr.axes) 
   mv_rotate3d(double(gr.axes),'off');
   fig=handle(gr.axes.parent);
   if ishandle(fig) & ~isBeingDestroyed(fig)
      delete([gr.axes;gr.surf;gr.colorbar.axes;gr.colorbar.bar;gr.cfactor;gr.ctext;...
      gr.xfactor;gr.xtext;gr.yfactor;gr.ytext;gr.zfactor;gr.ztext;gr.patch;...
      gr.colorbar.minrange;gr.colorbar.midrange;gr.colorbar.maxrange;gr.colorbar.frame1;...
      gr.colorbar.frame2;gr.colorbar.userange; gr.badim]);
   end
end
