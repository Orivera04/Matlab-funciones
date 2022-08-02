function schema
% Defines class properties

% Author(s): P. Gahinet
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:41:23 $

% Get handles of associated packages and classes
hDeriveFromPackage = findpackage('wavepack');
hDeriveFromClass   = findclass(hDeriveFromPackage, 'timeplot');
hCreateInPackage   = findpackage('speviews');

% Construct class
c = schema.class(hCreateInPackage, 'paramplot', hDeriveFromClass);

% Public properties
% Global list of estimated parameters
schema.prop(c,'AllParameters','handle vector');
