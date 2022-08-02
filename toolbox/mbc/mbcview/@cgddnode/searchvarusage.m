function [pOtherNodes, str, ic]=searchvarusage(ddnode,pItem)
%SEARCHVARUSAGE  Look for usage of variable in project
%
%  [NODES, STR, IC]=SEARCHVARUSAGE(DD,P_ITEM)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 08:23:48 $

pDD=address(ddnode);
pPROJ = address(project(ddnode));

% Search entire project for item but don't include the Variable Dictionary
% itself
pOtherNodes = pPROJ.preorder('findptr', pItem);
pOtherNodes = unique([pOtherNodes{:}]);
pOtherNodes = pOtherNodes(pOtherNodes~=pDD);

str = cell(length(pOtherNodes), 1);
ic = str;
for n = 1:length(str)
    str{n} = pOtherNodes(n).locationname;
    ic{n} = pOtherNodes(n).iconfile;
end

% Now search the Variable Dictionary for this item being used as part of a
% formula.  If this is not the case then we can remove the Variable
% Dictionary from the list of nodes using the item
pDDItems = pDD.listptrs;
for n = 1:length(pDDItems)
    if pDDItems(n).issymvalue
        pEq = pDDItems(n).getrhsptrs;
        if anymember(pItem, pEq)
            pOtherNodes = [pOtherNodes pDD];
            str = [str; {[pDD.locationname '/' pDDItems(n).getname]}];
            ic = [ic; {pDDItems(n).iconfile}];
        end
    end
end