function obj = delete(obj)
%% xregaxesinput/DELETE
%% removes object from view by deleting the layout inside it

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:31:24 $

if isempty(obj.grid) | ~isa(obj.grid,'xregcontainer')
   return
else
   delete(obj.grid);
   obj.grid=[];
end

