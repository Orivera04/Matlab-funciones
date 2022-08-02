function p=recursivesearch(nd,data)
%RECURSIVESEARCH  Search tree for nodes related to data
%
%  p=RECURSIVESEARCH(ND, DATA)  searchs down the tree from ND
%  and returns a list of node pointers that are related to DATA.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 08:27:43 $

nd=address(nd);
ch=nd.children;
M=nd.getdata;

% Get the various operating point sets
deps = [];
deps = [deps,  M.get('oppoints')];

% Extract the models
obfuncs = M.get('objectivefuncs');
obmod = [];
for i = 1:length(obfuncs)
   deps = [deps, obfuncs(i).get('modptr')];
end
cons = M.get('modelconstraints');
conmod = [];
for i = 1:length(cons)
   deps = [deps, cons(i).get('modptr')];
end

if (data==M) || any(deps==data)
   p=nd;
else
   p=[];
end

for n=1:length(ch)
   p=[p ch(n).recursivesearch(data)];   
end


