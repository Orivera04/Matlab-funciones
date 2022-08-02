function NewNode= addtolistview(T,vals,nodes,IL)
%ADDTOLISTVIEW   Create nodes in activex list
%
%  addtolistview(node, vals, AXnodes, IL)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 08:24:38 $


T=address(T);

ic=bmp2ind(IL,T.iconfile);

NewNode=nodes.Add;
NewNode.Key=T.genkey;
NewNode.Text=T.name;
NewNode.SmallIcon=ic;
NewNode.tag=double(T);
for n=1:length(vals)
   set(NewNode,'SubItems',n,vals{n});   
end
