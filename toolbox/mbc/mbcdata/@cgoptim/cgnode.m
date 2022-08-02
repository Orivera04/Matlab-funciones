function n=cgnode(obj,p_cont,p,recurse)
%CGNODE  return a cgnode object
%
%  ND=CGNODE(O,PTR_E,RECURSE) creates a cgnode object for the 
%  optimization object O.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:52:59 $

n=address(cgoptimnode(p));
n.name(getname(obj));