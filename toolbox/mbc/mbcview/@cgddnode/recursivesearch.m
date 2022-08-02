function p=recursivesearch(nd,data)
%RECURSIVESEARCH  Search tree for nodes related to data
%
%  p=RECURSIVESEARCH(ND, DATA)  searchs down the tree from ND
%  and returns a list of node pointers that are related to DATA.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:23:43 $

% Default for cgddnode is to look in ptrlist
p=[];
if isa(data,'xregpointer')
    if any(nd.ptrlist==data)
        p=address(nd);
    end
end