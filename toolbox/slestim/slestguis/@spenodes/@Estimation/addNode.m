function hOut = addNode(this, varargin)
% ADDNODE Add children to this node

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/11 00:38:33 $

% REM: Put a for loop here to handle addition of multiple children.
% Overwrites the parent ADDNODE method

% If no leaf is supplied, add a default child
if isempty( varargin )
  leaf = this.createChild;
else
  leaf = varargin{1};
end

view = find(this, '-class', 'spenodes.Viewer');

if ~isempty(view) && isa( leaf, 'explorer.node' )
  connect( leaf, view, 'right' );
elseif isempty(view) && isa( leaf, 'explorer.node' )
  connect( leaf, this, 'up' );
elseif isempty(leaf)
  warning( 'Leaf node is empty.' )
else
  error( '%s is not of type @explorer/@node', class(leaf) )
end

if nargout > 0
  hOut = leaf;
end
