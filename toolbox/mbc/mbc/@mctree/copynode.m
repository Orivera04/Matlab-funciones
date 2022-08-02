function newnd=copynode(nd)
%COPYNODE  Copy a branch of a tree
%
%  NEWND=COPYNODE(ND)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:47:39 $

% temporarily detach from parent
P=nd.Parent;
nd.Parent=xregpointer;
pointer(nd);

% (1) Get pointers used in this branch
refs= preorder(nd,'getptrs');
if iscell(refs)
   refs= [refs{:}];
end
refs = unique(refs);
% remove null pointers from list
refs= refs(refs~=0);


% (2) Copy data into new heap locations and map new pointers
newrefs=copy(refs);

% re-attach one copy to original parent
nd.Parent=P;
pointer(nd);

% get new copy of this node to return
ind=find(refs==nd.node);

newnd=info(newrefs(ind));