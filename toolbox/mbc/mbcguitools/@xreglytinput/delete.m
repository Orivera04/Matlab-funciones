function obj = delete(obj)
%% xreglytinput/DELETE
%% removes object from view by deleting the layout inside it

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:32:15 $

if isempty(obj.lyt) | ~isa(obj.lyt,'xregcontainer')
   return
else
   delete(obj.lyt);
   obj.lyt=[];
end

