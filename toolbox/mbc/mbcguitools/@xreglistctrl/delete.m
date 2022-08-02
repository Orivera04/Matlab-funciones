function delete(obj)
%% xreglistctrl/DELETE
%% removes object from view by deleting the slider, the frame 
%% and all controls inside

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:32:06 $

numControls = size(obj);
controls = get(obj,'controls');

if isempty(obj.slider) | ~ishandle(obj.slider)
   return
else
   delete(obj.slider);
   delete(obj.frame);
   obj.slider=[];
   obj.frame=[];
   for i = 1:numControls
      delete(controls{i});
   end
end

