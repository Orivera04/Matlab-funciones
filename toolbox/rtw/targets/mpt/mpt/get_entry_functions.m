function entry = get_entry_functions(callTree)

% Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1.4.1 $
%   $Date: 2004/04/15 00:27:02 $

entry=[];
node = callTree.down;
while (node ~= 0)
    entry{end+1}=node.get;
    node = node.right;
end
