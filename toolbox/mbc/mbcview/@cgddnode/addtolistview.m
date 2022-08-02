function NewNode= addtolistview(T,vals,nodes,IL)
%ADDTOLISTVIEW Create nodes in activex list
%
%  addtolistview(node, vals, AXnodes, IL)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.2 $  $Date: 2004/02/09 08:23:04 $

% Variable Dictionary adds all of it's members

Tp=address(T);
ptrlist = T.ptrlist;

NewNode=[];
for i = 1:length(ptrlist)
   this = ptrlist(i).info;
   
   % get icon 
   iconbmp = Tp.iconfile(ptrlist(i));
   ic=bmp2ind(IL,iconbmp);
   
   % Get list values 
   [tags,vals]=listvals(T,ptrlist(i));
   
   % add node and set values
   NewNode= nodes.Add;
   NewNode.Key=Tp.genkey(ptrlist(i));
   NewNode.Text=getname(this);
   NewNode.SmallIcon=ic;
   NewNode.tag=double(Tp);
   for n=1:length(vals)
      set(NewNode,'SubItems',n,vals{n});  
   end
end
