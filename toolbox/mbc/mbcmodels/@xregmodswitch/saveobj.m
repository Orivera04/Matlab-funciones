function m= saveobj(m);
%XREGMODSWITCH/SAVEOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:53:50 $

for i=1:length(m.ModelList);
    m.ModelList{i}= saveobj(m.ModelList{i});
end
m.xregmodel= saveobj(m.xregmodel);
    
