function deleteproject(p)
%DELETEPROJECT Fast project deletion for Cage
%
%  DELETEPROJECT(PROJ) deletes the Cage project PROJ.  This method turns on
%  the "beingdeleted" flag in the project which shortcuts most of the
%  deletion checking that occurs in the children.  this method then takes
%  care of freeing all of the pointers itself.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:28:06 $

% Toggle the beingdleted flag to on
p.beingdel = 1;
xregpointer(p);

% Gather all pointers in project
ptrs = preorder(p, @getptrs);
ptrs = [ptrs{:}];

% Delete project tree
delete(p);

% Delete remaining pointers
ptrs = unique(ptrs);
freeptr(ptrs(isvalid(ptrs)));