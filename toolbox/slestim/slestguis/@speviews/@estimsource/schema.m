function schema
% SCHEMA Define class attributes

% Author(s): Bora Eryilmaz
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:41:06 $

% Get handles of associated packages and classes
hDeriveFromPackage = findpackage('wrfc');
hDeriveFromClass   = findclass(hDeriveFromPackage, 'datasource');
hCreateInPackage   = findpackage('speviews');

% Construct class
c = schema.class(hCreateInPackage, 'estimsource', hDeriveFromClass);

% Estimation results in this object
p = schema.prop(c, 'Estimation', 'handle');
p.AccessFlags.PublicSet = 'off';

% Parameter names
% RE: Takes snapshot at creation to insulate source from changes 
%     in the global list (reflected in Estimation) and thus maintain 
%     consistency between the source and view dimensions.
p = schema.prop(c, 'Parameters', 'string vector');
p.AccessFlags.PublicSet = 'off';
