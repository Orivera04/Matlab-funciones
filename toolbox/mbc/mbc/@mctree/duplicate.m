function Tnew = duplicate(T, ptrmethod)
%DUPLICATE Duplicate the tree node
%
%  Tnew = DUPLICATE(T) where T and Tnew are the old and new tree node
%  object respectively will make a copy of T and attach it to the same
%  parent node as T.  Pointers that are duplicated are found by calling the
%  getduplicationptrs method on the node and its children.
%
%  Tnew = DUPLICATE(T, PTRMETHOD) where PTRMETHD is a string or function
%  handle will instead use the given function for retrieving the duplication
%  pointers.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:47:43 $ 

if nargin==1
    ptrmethod = 'getduplicationptrs';
end

pParent = T.Parent;
pSelf = T.node;

% Gather pointers for duplication
pDup = preorder(T, ptrmethod);
if iscell(pDup)
    pDup = unique([pDup{:}]);
else
    pDup = unique(pDup);
end
% If pDup is empty then the duplication process is effectively terminated.
% This is a good way of preventing duplication of nodes that don't support
% it
if ~isempty(pDup)
    % Ensure that noone has returned the immediate parent
    pDup = pDup(pDup~=pParent);
    
    % Copy the data to new heap locations
    oldwarn = warning('off', 'mbc:xregpointer:PointerMatch');
    [pNew, RefMap] = copy(pDup);
    warning(oldwarn);
    
    % Find the location of the new version of this node
    pNew = RefMap{2}(RefMap{1}==pSelf);
    if pParent~=0
        pParent.AddChild(pNew);
    end
    Tnew = pNew.info;
else
    Tnew = T;
end