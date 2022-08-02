function ptr = find(D,thing)
%FIND Find an item in the variable dictionary
%
%  PTR = FIND(DD, ITEM) where ITEM is a pointer or string.  PTR is either a
%  pointer to the found item or empty if no item could be found.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:23:18 $

ptr = [];
if isa(thing,'xregpointer')
    % pointer
    ptr = thing(ismember(thing, D.ptrlist));
else
    % assume string
    if ~iscell(thing)
        thing = {thing};
    end
    nThings = length(thing);
    ptr = cell(size(thing));
    
    for m = 1:length(thing)
        for n = 1:length(D.ptrlist)
            dditem = D.ptrlist(n).info;
            if strcmp(thing{m}, getname(dditem)) ...
                    || any(strcmp(thing{m}, getaliaslist(dditem)))
                ptr{m} = D.ptrlist(n);
                break
            end 
        end
    end
    
    if length(ptr)==1
        ptr = ptr{1};
    end
end