function D = resetxregpointers(D,ref,ptr)
% cgOpPoint/resetxregpointers
% obj = resetxregpointers(obj)
%   empties the operating point object of xregpointers
% obj = resetxregpointers(obj,ref,ptr);
%   sets the ptr of the column referenced by ref to ptr
%   ref can be an index or the old xregpointer

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:52:13 $
if nargin == 3
    % change the referenced xregpointer
    if isa(ref,'xregpointer')
        ref = find(D.ptrlist==ref);
        if isempty(ref)
            return
        end
    elseif isa(ref,'double') 
        if ref>length(D.ptrlist) | ref<0
            return
        end
    end
    if isvalid(D.ptrlist(ref))
        D.orig_name{ref} = D.ptrlist(ref).getname;
    end
    D.ptrlist(ref) = ptr;
else
    % clear all xregpointers
    for i=1:length(D.ptrlist)
        if isvalid(D.ptrlist(i))
            D.orig_name{i} = D.ptrlist(i).getname;
        end
        D.ptrlist(i) = xregpointer;
    end
end