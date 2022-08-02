function repack(obj)
%  Synopsis
%     function repack(obj)
%
%     
%  Description
%     This function reapplies the packing command to the objects in question
%     If recurse is set to yes the packing is applied to all lower
%     level objects as well. 
%
%
%  See Also
%     methods xregcontainer

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:26 $

elements= obj.g.elements;

for k = 1:length(elements)
   if isa(elements{k},'xregcontainer')
      repack(elements{k});
   end
end

%Does not perform any packing with respect to the current frame.
%Essentially this is an abstract class.

