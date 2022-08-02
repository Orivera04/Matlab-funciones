function Node = loadobj(Node)
%LOADOBJ Method to update old versions of output node objects

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.6.1 $    $Date: 2004/02/09 08:27:25 $

if isstruct(Node) && ~isfield(Node, 'version')
    % Version 1 object structure - nothing to salvage.
    Node=struct('name', Node.name, ...
        'output', [], ...
        'version', 3, ...
        'cgcontainer', Node.cgcontainer); 
end

if Node.version < 3
    % Version 2 object structure - need to add the "first view" field
    Node.viewed = 0;
end

% Current version
Node.version = 3;

if isstruct(Node)
    Node = cgoptimoutnode(Node);
end