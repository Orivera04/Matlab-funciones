function C = getconstants(F)
%GETCONSTANTS Return cgconstant children of this node
%
%  C = GETCONSTANTS(F) returns the cgconstants that are in this feature

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:10:36 $

ptrs = F.eqexpr;
if ~isempty(ptrs)
    ptrs = [ptrs; ptrs.getptrs];
end
ptrs = unique(ptrs);

if ~isempty(ptrs)
    const = pveceval(ptrs, 'isa', 'cgconstant');
    C = ptrs([const{:}]);
else
    C = null(xregpointer, [0,1]);
end