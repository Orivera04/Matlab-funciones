function p=recursivesearch(nd,data)
%RECURSIVESEARCH  Search tree for nodes related to data
%
%  P=RECURSIVESEARCH(ND, DATA)  searchs down the tree from ND
%  and returns a list of node pointers that are related to DATA.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.2 $  $Date: 2004/02/09 08:24:30 $

nd=address(nd);
M=nd.getdata;
ptrs = M.getptrs;
if data==M || any(ptrs==data)
   p=nd;
else
   p=[];
end

ch=nd.children;
for n=1:length(ch)
   p=[p ch(n).recursivesearch(data)];   
end