function outstruc = getnamespace(obj, varargin)
%GETNAMESPACE Return or view the OPC server namespace.
%   S = GETNAMESPACE(Obj) returns the entire namespace of the server
%   associated with the opcda object specified by Obj. S is an n-by-1
%   structure array with the fields Name,  FullyQualifiedID, and NodeType.
%   Name is a descriptive name; FullyQualifiedID is the fully qualified
%   ItemID of that node; NodeType defines the node as a 'branch' node
%   (containing other nodes) or 'leaf' node (containing no other nodes).
%
%   By default the namespace is returned in a flat structure.
%
%   S = GETNAMESPACE(Obj,'hierarchical') returns the namespace in a
%   hierarchical structure. S is a recursive structure containing the
%   fields Name, FullyQualifiedID, NodeType and Nodes. Nodes contains the
%   same fields as S (Name, FullyQualifiedID, NodeType and Nodes) for all
%   nodes in the current branch.
%
%   Examples
%       da = opcda('localhost', 'Matrikon.OPC.Simulation');
%       connect(da);
%       nsFlat = getnamespace(da)
%       nsHier = getnamespace(da,'hierarchical')
%       nsHier(1).Nodes
%
%   See also FLATNAMESPACE, SERVERITEMS.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.7 $  $Date: 2004/02/01 22:06:18 $

% Error check the OPC object
errorargmsg = nargchk(1,inf,nargin);
if ~isempty(errorargmsg)
    rethrow(mkerrstruct('opc:getnamespace:inargs',errorargmsg));
end
if length(obj)>1
    rethrow(mkerrstruct('opc:getnamespace:vecnotsupported'));
elseif ~isvalid(obj)
    rethrow(mkerrstruct('opc:getnamespace:objinvalid'));
end

% Error checking on additional arguments
isFlat = true;
if any(strcmpi(varargin, 'hierarchical')),
    % Return the hierarchical namespace
    isFlat = false;
    varargin(strcmpi(varargin, 'hierarchical'))=[];
end

try
    ns = udgetnamespace(getudd(obj), varargin{:});
    if isFlat
        outstruc = flatnamespace(ns);
    else
        outstruc = ns;
    end
catch
    rethrow(mkerrstruct(lasterror));
end
