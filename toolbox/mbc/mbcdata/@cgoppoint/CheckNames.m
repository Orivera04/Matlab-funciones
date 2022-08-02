function [op,changed_i,oldnames,newnames] = CheckNames(op,pr)
% [op,changed_i] = CheckNames(op)
% Ensure unassigned columns have unique names within project

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:51:07 $

check = ~isvalid(op.ptrlist) | ...
    op.created_flag==1;

check = find(check);

changed_i = []; oldnames = []; newnames = [];
for i = 1:length(check)
    oldname = op.orig_name{check(i)};
    newname = deblank(uniquename(pr,oldname));
    if ~strcmp(oldname,newname)
        changed_i = [changed_i check(i)];
        oldnames = [oldnames {oldname}];
        newnames = [newnames {newname}];
        op.orig_name{check(i)} = newname;
    end
end
