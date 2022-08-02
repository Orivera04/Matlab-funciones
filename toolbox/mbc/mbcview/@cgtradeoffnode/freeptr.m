function freeptr(nd)
%FREEPTR React to cgtradeoffnode pointer release
%
%  FREEPTR(NODE)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:37:25 $

p = project(nd);
if ~beingdeleted(p)
    % Tell variables in project to remove the store associated with this
    % tradeoff
    pDD = getdd(p);
    pDD.deletevariablestore(nd.ObjectKey);
    
    % Free all other pointers if they are not held elsewhere in the project
    our_ptrs = getptrs(nd);
    our_ptrs = our_ptrs(our_ptrs~=address(nd));
    ptnow = preorder(p, @getptrs);
    ptnow = [ptnow{:}];
    freeptr(our_ptrs(~ismember(our_ptrs, ptnow)));
end
