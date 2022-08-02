function p=recursivesearch(nd,data)
%RECURSIVESEARCH Search tree for nodes related to data
%
%  p=RECURSIVESEARCH(ND, DATA) searchs down the tree from ND and returns a
%  list of node pointers that are related to DATA.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:24:10 $

nd = address(nd);
ch = nd.children;
F = nd.getdata;
mdl = F.get('model');
if data==F || (~isempty(mdl) && (mdl==data))
    p = nd;
else
    p = [];
end
for n = 1:length(ch)
    p = [p ch(n).recursivesearch(data)];
end