function schema
% SCHEMA Defines class properties

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:41:10 $

% Get handles of associated packages and classes
hCreateInPackage   = findpackage('speviews');
hDeriveFromClass   = findclass(hCreateInPackage, 'paramplot');

% Construct class
c = schema.class(hCreateInPackage, 'gradientplot', hDeriveFromClass);
