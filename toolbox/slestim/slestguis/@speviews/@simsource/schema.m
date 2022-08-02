function schema
% SCHEMA Define class attributes

% Author(s): Bora Eryilmaz
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/16 22:21:40 $

% Get handles of associated packages and classes
hDeriveFromPackage = findpackage('wrfc');
hDeriveFromClass   = findclass(hDeriveFromPackage, 'datasource');
hCreateInPackage   = findpackage('speviews');

% Construct class
c = schema.class(hCreateInPackage, 'simsource', hDeriveFromClass);

% Estimation results in this object
p = schema.prop(c, 'Estimation', 'handle');
p.AccessFlags.PublicSet = 'off';

% All output ports involved in this estimation
p = schema.prop(c, 'OutputPort', 'MATLAB array');
p.AccessFlags.PublicSet = 'off';
