function D = remove(D,thing)
%REMOVE  Remove an item from the Variable Dictionary
%
%  D = remove(D,ptr)
%  D = remove(D,name)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.2 $  $Date: 2004/02/09 08:23:44 $

if isa(thing,'xregpointer')
    for k = 1:length(thing)
        itemindx =  (thing(k) == D.ptrlist);
        if any(itemindx);
            if thing.issymvalue
                D.numsymvars = D.numsymvars - 1;
            end
            D.ptrlist = D.ptrlist(~itemindx);
            freeptr(thing(k));
            pointer(D);
        end
    end
else
    % name
    ptr = find(D, thing);
    if ~isempty(ptr)
        if strcmp(ptr.getname, thing)
            % Remove if the name matches
            remove(D, ptr);
            D = info(address(D));
        else
            % Remove alias
            ptr.info = ptr.removealias(thing);
            pointer(D);
        end
    end    
end