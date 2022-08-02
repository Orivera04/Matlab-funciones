function freeptr(nd);
%FREEPTR React to cgcontainer pointer release
%
%  FREEPTR(NODE)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:21:55 $

if isa(nd.data,'xregpointer')
    % get pointers from object
    p = project(nd);
    if ~beingdeleted(p)
        sub_ptrs = getptrs(nd.data.info);
        ptrs = [nd.data, sub_ptrs(:)'];
        ptnow = preorder(p, @getptrs);
        ptnow = [ptnow{:}];
        freeptr(ptrs(~ismember(ptrs, ptnow)));
    end
end