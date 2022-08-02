function ret=canpaste(nd,data)
% CANPASTE  Indicate whether node can paste data
%
%  OUT = CANPASTE(NODE,DATA)  returns 1/0 to indicate whether the node is
%  currently in a state to paste in the given data.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.3 $  $Date: 2004/02/09 08:21:39 $

if isnumeric(data)
   h=cgbrowser;
   d=h.getViewData;
   if d.currentviewinfo==3
      % only table view can paste
      jt = d.Handles.Table.Component;
      ret = jt.canPaste;
   else
      ret=0;
   end
else
   ret=0;
end
