function ptrs = listptrs(D, vartype, excludeopt);
%LISTPTRS  Return a pointer list of variable dictionary items
%
%  PTRS = LISTPTRS(D) returns the pointers to all of the current variable
%  dictionary items.
%  PTRS = LISTPTRS(D, TYPE) where TYPE is one of 'variable', 'constant' or
%  'formula' returns only the pointers to items of the specified type.
%  PTRS = LISTPTRS(D, TYPE, 'exclude') does not return the pointers to
%  items of the specified type.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:23:33 $

ptrs = D.ptrlist;

if nargin>1
    keep = false(size(ptrs));
    objlist = info(ptrs);
    if ~iscell(objlist)
        objlist = {objlist};
    end
    switch vartype
        case 'variable'
            for n = 1:numel(keep)
                if ~isconstant(objlist{n}) && ~issymvalue(objlist{n})
                    keep(n) = true;
                end
            end        
        case 'formula'
            for n = 1:numel(keep)
                if issymvalue(objlist{n})
                    keep(n) = true;
                end
            end 
        case 'constant'
            for n = 1:numel(keep)
                if isconstant(objlist{n})
                    keep(n) = true;
                end
            end
            
    end
    if nargin>2 && strcmp(excludeopt, 'exclude')
        keep = ~keep;
    end
    ptrs = ptrs(keep);
end