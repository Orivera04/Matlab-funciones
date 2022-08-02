function delete(gr)
%GRAPH1D/DELETE   Delete a 1D graph object.
%   DELETE(GR) deletes the 1D graph object gr.  The handle
%   that you still have will be a valid object but there will
%   no longer be valid data or graphical objects to use methods
%   on.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:18:48 $

hndls=[gr.axes;gr.line;gr.hist.axes;gr.hist.patch;gr.factorsel;gr.factortext;gr.patch;gr.badim];
if all(ishandle(hndls))
   delete(hndls);
end