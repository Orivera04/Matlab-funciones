function this = xregbdrydev( varargin )
%XREGBDRYDEV A node in a boundary modeling tree of models.
%
%  R = XREGBDRYDEV(NAME,...) is a boundary modeling tree node object
%  with the given NAME. XREGBDRYDEV objects are child objects of
%  XREGBDRYNODE. 
%  
%  See also: XREGBDRYNODE, MCTREE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.1 $    $Date: 2004/02/09 08:13:14 $ 

% If the first argument is an xregbdrynode, then return it
if nargin >= 1 & isa( varargin{1}, 'xregbdrydev' ),
    this = varargin{1};
    return
end

% Create parent object
parent = xregbdrynode( varargin{:} );

% Setup object structure
this = struct( ...
    'Version', 1.0, ...
    'Model', [], ...
    'BdryPoints', [], ...
    'LockedBdryPoints', [], ...
    'SpecialPoints', [], ...
    'LockedSpecialPoints', [] );

% Instantiate object
this = class( this, 'xregbdrydev', parent );

% Put object on heap, but only put if there were input arguments
if nargin >= 1,
    this = info( xregpointer( this ) ); 
end

return
