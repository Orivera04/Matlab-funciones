function NewNode = addtotreeview(T,nodes,IL,makevis,altparent)
%ADDTOTREEVIEW Create nodes in activex tree
%
%  ADDTOTREEVIEW(node, AXnodes, IL, makevis, altparent) adds the tradeoff
%  node to the activex tree.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $  $Date: 2004/02/09 08:37:09 $

T = address(T);
if nargin>4
   Pn = altparent;
else
   Pn = T.Parent;
end

% add self to Parent node
if isvalid(Pn)
   k = Pn.genkey;
else
   k = '';
end
ic = bmp2ind(IL,T.iconfile);

if ~isempty(k) && double(nodes.count) > 0
    % Find parent to add self beneath
    r = nodes.Item(k);
    NewNode = nodes.Add(r, 4, T.genkey(0), T.name, ic);
else
    NewNode = nodes.Add;
    NewNode.Key = T.genkey(0);
    NewNode.Text = T.name;
    NewNode.Image = ic;
end
set(NewNode,'tag',double(T));
if makevis>1 
    % Set this node to be expanded so that the children are visible
    NewNode.Expanded = true;
end

p = mbcprefs('mbc');
if getfeat(p, 'TradeoffListView');
    % Add a new node beneath the one we've just created.  This points to the
    % same tradeoff node but with a different subitem modifier.
    nodes.Add(NewNode, 4, T.genkey(1), 'Saved Inputs List', ic);
end


