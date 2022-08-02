function newName = getUniqueBlockName(name, system)
%GETUNIQUEBLOCKNAME

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 08:02:43 $

loop = 1;
newName = name;
while loop
   if isempty(find_system(system, 'SearchDepth', 1, 'Name', newName))
      loop=0;
   else
      newName = [name '(' num2str(loop) ')'];
      loop = loop+1;
   end
end