function n=cgnode(obj,p_cont,p,recurse)
%CGNODE  return a cgnode object
%
%  ND=CGNODE(E,PTR_E,RECURSE) creates a cgnode object for the 
%  expression object E, containing the data PTR_E (normally
%  a pointer to E).  If RECURSE is set to 1, nodes
%  are created for children of the cgexpr such as normalisers
%  inside tables.  CONTEXT is a pointer to the node which we will
%  be part of.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:12:56 $

n=address(cgmodelnode(p));
n.name(getname(obj));