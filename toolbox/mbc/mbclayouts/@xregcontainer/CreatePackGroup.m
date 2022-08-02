function CreatePackGroup(OBJ,GRP)
% CreatePackGroup  Add a tree of layouts to a packgroup
%
%  CreatePackGroup(LYT,GROUP) recurses down the layout tree
%  headed by LYT and sets the packgroup of all objects to 
%  GROUP
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:35:10 $


OBJ.g.PSobj=OBJ.g.container_getPSobj(GRP);  

h=OBJ.g.elements;
for n=1:length(h)
   if isa(h{n},'xregcontainer')
      CreatePackGroup(h{n},GRP);
   end
end
