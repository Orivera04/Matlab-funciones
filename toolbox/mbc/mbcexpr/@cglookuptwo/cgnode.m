function n=cgnode(obj,p_cont,p,recurse)
%CGNODE  return a cgnode object
%
%  ND=CGNODE(E,CONTEXT,PTR_E,RECURSE) creates a cgnode object for the 
%  expression object E, containing the data PTR_E (normally
%  a pointer to E).  If RECURSE is set to 1, nodes
%  are created for children of the cgexpr such as normalisers
%  inside tables.  CONTEXT is a pointer to the node which we will
%  be part of.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:11:28 $

if ~isempty(p_cont)
   n=address(tablenode(p_cont.info,p));
else
   n=address(cgtablenode(p));
end
n.name(getname(obj));
if recurse
   % create and attach child nodes for normalisers
   if ~isempty(obj.Xexpr);
      n_sub=cgnode(obj.Xexpr.info,p_cont,obj.Xexpr,0);
      n.AddChild(n_sub);    
   end
   if ~isempty(obj.Yexpr);
      n_sub=cgnode(obj.Yexpr.info,p_cont,obj.Yexpr,0);
      n.AddChild(n_sub);    
   end  
end