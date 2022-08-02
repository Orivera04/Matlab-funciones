function fns = flatnamespace(ns)
%FLATNAMESPACE Flatten a hierarchical OPC Namespace
%   FNS = FLATNAMESPACE(NS) flattens the hierarchical namespace NS, by
%   recursively removing all information in the Nodes fields and placing
%   that information into additional entries in the root structure of FNS.
%   You obtain a hierarchical namespace using the 'hierarchical' flag in
%   GETNAMESPACE.
%
%   Examples
%       da = opcda('localhost', 'Matrikon.OPC.Simulation');
%       connect(da);
%       hierNS = getnamespace(da, 'hierarchical')
%       flatNS = flatnamespace(hierNS)
%
%   See also OPCDA/GETNAMESPACE, OPCDA/SERVERITEMS.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.2 $  $Date: 2004/02/01 22:06:50 $

fns = struct('Name', [], 'FullyQualifiedID', [], 'NodeType', []);
fns(1)=[];
parent = '';

% Remember the recursion limit and set it to inf
recLimit = get(0,'RecursionLimit');
set(0,'RecursionLimit',inf);
fns = flatten(fns, ns, parent)';
set(0, 'RecursionLimit', recLimit);

%-----------------------------------------------------------
function fns = flatten(fns, ns, parent)
% Recurse through the ns structure, flattening it out
for k=1:length(ns)
    if isempty(parent),
        thisName = ns(k).Name;
    else
        thisName = sprintf('%s.%s', parent, ns(k).Name);
    end
    fns(end+1) = struct('Name', thisName, ...
        'FullyQualifiedID', ns(k).FullyQualifiedID, ...
        'NodeType', ns(k).NodeType);
    if ~isempty(ns(k).Nodes),
        fns = flatten(fns, ns(k).Nodes, thisName);
    end
end
