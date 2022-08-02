function Tnew = duplicatenode(T, SI)
%DUPLICATENODE Duplicate a Cage project node
%
%  NEWND = DUPLICATENODE(ND, P_SUBITEM) creates a new copy of node ND.
%  NEWND is the address of the resulting new node that is created.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.8.2 $    $Date: 2004/02/09 08:24:50 $ 

% Call mctree duplicate method for basic duplication process
Tnew = address(duplicate(T));

% Sort out names.  This works by getting two lists - the old nodes and the
% new nodes - and passing pairs of nodes through the function usesamename
% to determine whether each node needs to be uniquely renamed.
pOld_nodes = preorder(T, 'address');
if iscell(pOld_nodes)
    pOld_nodes = [pOld_nodes{:}];
end
pNew_nodes = Tnew.preorder('address');
if iscell(pNew_nodes)
    pNew_nodes = [pNew_nodes{:}];
end

nodes = info(pNew_nodes);
if ~iscell(nodes)
    nodes = {nodes};
end
nameok = pvecinputeval(pOld_nodes, 'usesamename', nodes);

PROJ = project(T);
for n = 1:length(nodes)
    if ~nameok{n}
        new_nm = uniquename(PROJ, name(nodes{n}));
        name(nodes{n}, new_nm);
    end
end