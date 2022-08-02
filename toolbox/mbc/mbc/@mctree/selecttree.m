function key= selecttree(T,Browser);
% MCTREE/SELECTTREE select tree node on treeview control

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 06:48:06 $



key= treeview(T,'key');
nodes= get(Browser,'nodes');
Item= get(nodes,'Item',key);
set(Browser,'SelectedItem',Item);