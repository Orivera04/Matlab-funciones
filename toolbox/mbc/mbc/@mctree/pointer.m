function p= pointer(T,newp);
% MCTREE/POINTER manage dynamic copy of tree
%
% p= pointer(T)
%  This function will allocate dynamic memory for a tree node if none has been 
%  allocated previously or update the dynamic copy of the tree node if it exists.
%
%  This function MUST be called to update the dynamic copy of T after changing
%  anything in T. This function is normally required at the end of any child class
%  methods where class properties have been changed.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 06:48:02 $



if nargin>1
   if T.node~=0
      delete(T);
   end
   p= newp;
   T.node=p;   
elseif T.node==0
   p= xregpointer([]);
   T.node= p;
else
   p= T.node;
end
p.info= T;
