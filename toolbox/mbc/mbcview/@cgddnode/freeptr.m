function freeptr(nd);
%FREEPTR React to variable dictionary pointer release
%
%  FREEPTR(DD)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:23:20 $

refs = nd.ptrlist;
if ~isempty(refs)
    p = project(nd);
    if ~beingdeleted(p)
        ptnow = preorder(p, @getptrs);
        if iscell(ptnow)
            ptnow = [ptnow{:}];
        end
        freeptr(refs(~ismember(refs, ptnow)));
    end
end
