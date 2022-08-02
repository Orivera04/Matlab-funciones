function nd=addcgitems(nd,chld)
%ADDCGITEMS  Add multiple items to Cage project
%
%  ND=ADDCGITEMS(ND,ITEMS)  adds the items specified in the
%  cell array or pointer array ITEMS to this node.
%
%  Note that no unique name checking is preformed in this function.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 08:24:36 $


if iscell(chld)
   for k=1:length(chld)
      nd=AddChild(nd,chld{k});
   end
else
   % assume it is a pointer vector
   for k=1:length(chld)
      nd=AddChild(nd,chld(k));
   end
end