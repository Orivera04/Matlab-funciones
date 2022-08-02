function Tnew = duplicatenode(T, pSI)
%DUPLICATENODE Duplicate a Cage projct node
%
%  NEWND = DUPLICATENODE(ND, P_SUBITEM) creates a new copy of node ND.  NEWND is the
%  resulting new node that is created
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.8.2 $    $Date: 2004/02/09 08:23:14 $ 

if pSI~=0
    % Duplicate the subitem.  New formulae link to the same
    % variables/constants.  
    NewItem = pSI.info;
    DD = address(T);
    % Find a new unique name
    newnm = uniquename(DD.project, getname(NewItem));  
    NewItem = setname(NewItem, newnm);
    
    % Remove the aliases
    NewItem = clearallalias(NewItem);
    
    pNewItem = xregpointer(NewItem);
    DD.add(pNewItem);
    Tnew = DD.info;
end