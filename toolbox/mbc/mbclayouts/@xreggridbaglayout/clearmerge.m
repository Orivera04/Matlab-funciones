function clearmerge(gr,coord)
%CLEARMERGE  Clear a merge block
%
%  CLEARMERGE(G,[R,C]) clears the merge block which has its top-left
%  corner at [R,C].
%  CLEARMERGE(G)  clears all of the merge blocks.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:36:16 $


if nargin>1
   managemerge(gr,'clearblock',coord);
else
   managemerge(gr,'clearall');
end

if get(gr,'boolpackstatus')
   repack(gr);
end
