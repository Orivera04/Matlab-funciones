function p=recursivesearch(nd,data)
%RECURSIVESEARCH  Search tree for nodes related to data
%
%  p=RECURSIVESEARCH(ND, DATA)  searchs down the tree from ND
%  and returns a list of node pointers that are related to DATA.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:27:53 $


nd=address(nd);
ch=nd.children;
M=nd.getdata;
c = cgbrowser;
pN = c.currentnode;
if data==M & ~isa(pN.info, 'cgoptimoutnode')
   p=nd;
else
   p=[];
end
for n=1:length(ch)
   p=[p ch(n).recursivesearch(data)];   
end
