function des = applyconstraints(des)
%APPLYCONSTRAINTS Reapply design constraints to current design
%
%  DES = APPLYCONSTRAINTS(DES) reapplies the current constraints to the
%  current design points.  Design points that are not fixed and are not
%  within the constraint envelope are removed.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:06:09 $ 

if ~isempty(des.constraints)
    idxFree = freepoints(des);
    in = evalnomemory(des.constraints, des.design(idxFree, :));
    if ~all(in)
        des = delete(des, 'indexed', idxFree(find(~in)));
    end
end