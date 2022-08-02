function  add(obj, ctrl,idx)
%  Synopsis
%     function  add(obj, ctrl,idx)
%
%  Description
%     Adds a new control to the current xregcontainer It is considered that
%     the new control will be just added to the end of the
%     current list of controls.
%
%     If idx is specified then the control is added at the specific position.
%     Any control in the position will be deleted!
%
%  Example
%
%
%  See Also

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:12 $


%Retrieve elements
elements = obj.g.elements;
if nargin == 2
   len = length(elements) + 1;
   elements(end+1) = {ctrl};

elseif nargin == 3
   if (length(elements) >= idx)
      delete(elements{idx});
   end
   elements(idx) = {ctrl};
end

%Restore elements
obj.g.elements = elements;

% ask for a repack
if get(obj,'BOOLPACKSTATUS')
   repack(obj);
end



