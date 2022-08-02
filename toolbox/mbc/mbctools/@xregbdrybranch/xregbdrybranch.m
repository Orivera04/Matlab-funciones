function this = xregbdrybranch( varargin )
%XREGBDRYBRANCH A root of a subtree of the boundary modeling tree
%
%  R = XREGBDRYBRANCH(NAME,'Stages',N) is a boundary modeling sub-tree root
%  node object with the given name, NAME. The stages N can be 0 (response),
%  1 (local) or 2 (global).
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:12:55 $ 

% XREGBDRYBRANCH
%        Stages: 0 (response), 1 (local) or 2 (global)
%  xregbdryroot: parent object
%    
% These are essentially xregbdryroot objects except they should look to
% their parent in the tree to get data. They also need to know how to
% deal with that data, e.g, pass only global points to global models.
% On 'export' of the global constraint, may need to modify the Variables
% field of the parent conbase object to reflect which inputs should be
% considered. The Stages field indicates what part of the factor space
% is being constrained.
% 
% [ ] Data: look to parent in tree versus store their own pointer?
% 
% [ ] Need to check that all relevent methods for conbase and child
% objects support the variable inclusion/exclusion.

% If the first argument is an xregbdrybranch, then return it
if nargin >= 1 & isa( varargin{1}, 'xregbdrybranch' ),
    this = varargin{1};
    return
end

% Create parent object
if nargin < 1,
    parent = xregbdryroot;
else
    parent = xregbdryroot( varargin{1}, 'NumStages', 1 );
end
    
% Stages
if nargin < 3,
    stages = 1;
else
    stages = floor( varargin{3} );
    stages = max( stages, 0 );
    stages = min( stages, 2 );
end

% Setup object structure
this = struct( ...
    'Version', 1.0, ...
    'Stages', stages );

% Instantiate object
this = class( this, 'xregbdrybranch', parent );

% Put object on heap if and only if there are input arguments
if nargin >= 1,
    this = info( xregpointer( this ) ); 
end

return
