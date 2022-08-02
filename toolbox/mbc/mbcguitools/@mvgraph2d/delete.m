function delete(gr)
%DELETE Delete function for mvGraph2D object.
%   DELETE(GR) deletes the graph object GR.  This will
%   remove all graphical objects that are part of the object
%   and hence make GR unusable.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:19:02 $

delete([gr.axes;gr.line;gr.image;gr.colorbar.axes;gr.colorbar.bar; ...
        gr.xfactor;gr.xtext;gr.yfactor;gr.ytext;gr.patch;gr.badim]);