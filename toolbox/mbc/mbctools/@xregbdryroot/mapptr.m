function br = mapptr( br, refmap )
%MAPPTR A short description of the function
%
%  BR = MAPPTR(BR,REFMAP)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 08:13:35 $ 

br.xregbdrynode = mapptr( br.xregbdrynode, refmap );
br.Best         = mapptr( br.Best,         refmap );

for i=1:length(br.Data)
    br.Data{i}  = mapptr( br.Data{i},         refmap );
end