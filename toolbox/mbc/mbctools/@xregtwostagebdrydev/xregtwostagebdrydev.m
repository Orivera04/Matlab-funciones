function this = xregtwostagebdrydev( varargin )
%XREGTWOSTAGEBDRYDEV Tree node object for two-stage boundary constraints.
%
%  R = XREGBDRYDEV(NAME,...) is a boundary modeling tree node object with
%  the given NAME. XREGTWOSTAGEBDRYDEV objects are child objects of
%  XREGBDRYDEV. 
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:20:36 $ 

% XREGTWOSTAGEBDRYDEV 
%        LocalParamters: parameters for the local models
%           xregbdrydev: parent object
% 
% An xregbdrydev for two-stage boundary constraints.
% 
% Methods:
% 
%     localconstraint( bdev, num )
%         Returns the boundary constraint for the num-th sweep
%         

% If the first argument is an xregtwostagebdrydev, then return it
if nargin >= 1 & isa( varargin{1}, 'xregtwostagebdrydev' ),
    this = varargin{1};
    return
end

% Create parent object
parent = xregbdrydev( varargin{:} );

% Setup object structure
this = struct( ...
    'Version', 1.0, ...
    'LocalParameters', [] );

% Instantiate object
this = class( this, 'xregtwostagebdrydev', parent );

% Put object on heap, but only put if there were input arguments
if nargin >= 1,
    this = info( xregpointer( this ) ); 
end

return