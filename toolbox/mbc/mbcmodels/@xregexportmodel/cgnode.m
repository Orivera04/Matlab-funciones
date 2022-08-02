function n=cgnode(obj,p_cont,p,recurse)
%CGNODE  return a cgnode object
%
%  ND=CGNODE(E,PTR_CONTEXT,PTR_E,RECURSE) creates a cgnode object for the 
%  expression object E, containing the data PTR_E (normally
%  a pointer to E).  If RECURSE is set to 1, nodes
%  are created for children of the expr such as normalisers
%  inside tables.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:47:14 $

n=[];

% No recursion is possible in model objects