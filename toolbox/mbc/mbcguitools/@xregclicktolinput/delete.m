function obj = delete(obj)
%% xregclicktolinput/DELETE
%% removes object from view by deleting all uicontrols

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:31:34 $

if any([isempty(obj.clickedit),...
      isempty(obj.text),...
      isempty(obj.tolerancetext),...
      isempty(obj.tolerance),...
      ~ishandle(obj.text)])
   return
else
   delete(obj.clickedit);
   delete(obj.text);
   delete(obj.tolerancetext);
   delete(obj.tolerance);
   obj.text = [];
   obj.clickedit=[];
   obj.tolerancetext = [];
   obj.tolerance = [];
end

