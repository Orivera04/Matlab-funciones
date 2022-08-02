function pAllowed = aliasallowed(ddnode, pItem)
%ALIASALLOWED Return the list of items that item can be an alias of
%
%  PALLOWED = ALIASALLOWED(DD, PITEM) returns the list of pointers to items
%  that PITEM can be made an alias of.  The list is restricted if PITEM is
%  a variable or constant and is in a formula.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 08:23:05 $ 

pAllowed = listptrs(ddnode);
if ~pItem.issymvalue
    % look for item in symvalues
    mySym = insymval(ddnode, pItem);
    if ~isempty(mySym)
        % only allow a change to a similar type of item, i.e. constant to
        % constant or variable to variable
        allowed = false(size(pAllowed));
        if pItem.isconstant
            for n=1:length(allowed)
                if pAllowed(n).isconstant
                    allowed(n) = true;
                end
            end
        else  
            for n=1:length(allowed)
                if ~pAllowed(n).isconstant
                    allowed(n) = true;
                end
            end
        end
    end
end

% Remove self
pAllowed = pAllowed(pAllowed~=pItem);