function this = xregbdrynode( varargin )
%XREGBDRYNODE Abstract class to handle the boundary modeling tree.
%
%  NODE = XREGBDRYNODE(NAME,...) is a boundary modeling tree node object with
%  the given NAME. XREGBDRYNODE objects are child objects of MCTREE.
%  
%  See also: MCTREE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.1 $    $Date: 2004/02/09 08:13:22 $ 

% If the first argument is an xregbdrynode, then return it
if nargin >= 1 & isa( varargin{1}, 'xregbdrynode' ),
    this = varargin{1};
    return
end

% Create parent object
parent = mctree( varargin{:} );

% Setup object structure
this = struct( ...
    'Version', 1.0 );

% Instantiate object
this = class( this, 'xregbdrynode', parent );

% Put object on heap, but only put if there were input arguments
if nargin >= 1,
    this = info( xregpointer( this ) ); % CHECK ME!
end

return
