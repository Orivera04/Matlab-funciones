function NewNode= addtotreeview(T,nodes,IL,makevis,altparent)
%ADDTOTREEVIEW   Create nodes in activex tree
%
%  addtotreeview(node, AXnodes, IL, makevis, altparent)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 08:24:40 $


T=address(T);
if nargin>4
   Pn=altparent;
else
   Pn=T.Parent;
end

% add self to Parent node
if isvalid(Pn)
   k=Pn.genkey;
else
   k='';
end
ic=bmp2ind(IL,T.iconfile);

if ~isempty(k) & double(nodes.count) > 0 
   r = nodes.Item(k);
   NewNode = nodes.Add(r,4,T.genkey,T.name,ic);
else
   NewNode = nodes.Add;
   NewNode.Key=T.genkey(0);
   NewNode.Text=T.name;
   NewNode.Image=ic;
end
set(NewNode,'tag',double(T));
if makevis>1 
    % Set this node to be expanded so that the children are visible
    NewNode.Expanded = true;
end
