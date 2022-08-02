function  replace(obj, ctrl,idx)
%  Synopsis
%     function  replace(obj, ctrl,idx)
%
%  Description
%     Adds a new control to the current xregcontainer at point idx.
%     Any control in the position will have it's reference removed!
%
%  Example
%
%
%  See Also
%     Methods xregcontainer

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:35:27 $


%Retrieve elements
elements= obj.g.elements;

elements{idx} = ctrl;

%Restore elements
obj.g.elements= elements;
if obj.g.boolpackstatus
   repack(obj);
end
obj.g.NeedRepack= false;


