function obj = delete(obj)
%% xregtextinput/DELETE
%% removes object from view by deleting all uicontrols

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:33:58 $

if isempty(obj.hnd) | ~ishandle(obj.hnd)
   return
else
   delete(obj.hnd);
   obj.hnd=[];
end

