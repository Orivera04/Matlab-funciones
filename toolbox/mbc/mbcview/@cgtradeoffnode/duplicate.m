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

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:37:24 $ 

% Call parent duplicate method
if nargin==1
    Tnew = duplicate(T.cgnode);
else
    Tnew = duplicate(T.cgnode, ptrmethod);
end

% Generate a new unique object key
oldkey = Tnew.ObjectKey;
Tnew.ObjectKey = guidarray(1);

% Duplicate tradeoff data stores
pDD = getdd(project(Tnew));
pDD.duplicatevariablestore(oldkey, Tnew.ObjectKey);

% Add another size lock to each table
passign(Tnew.Tables, pveceval(Tnew.Tables, @addsizelock, Tnew.ObjectKey));

xregpointer(Tnew);
