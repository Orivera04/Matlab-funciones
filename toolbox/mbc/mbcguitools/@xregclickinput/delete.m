function obj = delete(obj)
%% xregconstinput/DELETE
%% removes object from view by deleting all uicontrols

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:31:29 $

if isempty(obj.clickedit) |  isempty(obj.text) | ~ishandle(obj.text)
   return
else
   delete(obj.clickedit);
   delete(obj.text);
   obj.text=[];
   obj.clickedit=[];
end

