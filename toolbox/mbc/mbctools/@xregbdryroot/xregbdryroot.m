function this = xregbdryroot( varargin )
%XREGBDRYROOT A root node in a boundary modeling tree of models.
%
%  R = XREGBDRYROOT(NAME,'NumStages',N) is a boundary modeling tree root
%  node object with the given name, NAME, and number of stages, N.  
%
%  A copy of the object will be put on the heap if and only if there are
%  input areguments.
%  
%  XREGBDRYROOT objects are child objects of XREGBDRYNODE. 
%
%  See also: XREGBDRYNODE, MCTREE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.7.6.1 $    $Date: 2004/02/09 08:13:44 $ 

% If the first argument is an xregbdrynode, then return it
if nargin >= 1 & isa( varargin{1}, 'xregbdryroot' ),
    this = varargin{1};
    return
end

% Create parent object
if nargin < 1,
    parent = xregbdrynode;
else
    parent = xregbdrynode( varargin{1} );
end

% Number of stages
if nargin < 3,
    ns = 1;
else
    ns = floor( varargin{3} );
    ns = max( ns, 1 );
    ns = min( ns, 2 );
end

% Setup object structure
this = struct( ...
    'Version', 1.0, ...
    'Data', [], ...      % Pointers (?) to data
    'Best', [], ...      % List of best children
    'NumStages', ns, ... % Number of stages 
    'Friend', [] );      % Friend model to do coding

% Instantiate object
this = class( this, 'xregbdryroot', parent );

% Put object on heap if and only if there are input arguments
if nargin >= 1,
    this = info( xregpointer( this ) ); 
end

return
