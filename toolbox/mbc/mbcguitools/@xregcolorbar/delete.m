function delete(gr)
%XREGCOLORBAR/DELETE   Deletes xregcolorbar HG objects
%   DELETE(GR) deletes the graph object in gr.
%   Note that this actually only deletes the HG
%   objects associated with GR.  MATLAB will still
%   treat GR as a valid object.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:31:19 $



delete([gr.colorbar.axes;gr.colorbar.bar;gr.cfactor;gr.ctext;...
      gr.patch;...
      gr.colorbar.minrange;gr.colorbar.midrange;gr.colorbar.maxrange;gr.colorbar.frame1;...
      gr.colorbar.frame2;gr.colorbar.userange]);
