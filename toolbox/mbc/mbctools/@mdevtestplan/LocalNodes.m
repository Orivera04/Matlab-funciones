function pLocal = LocalNodes(T,Index)
%LOCALNODES List of local model nodes within test plan
%
%  pLocal= LOCALNODES(T,Index)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:07:18 $

if numstages(T)==2
    pLocal= children(T,'children');
    pLocal= [pLocal{:}];
else
    pLocal= null(xregpointer,1,0);
end
