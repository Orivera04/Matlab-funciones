function schema
% SCHEMA Defines properties for @patternsearch class

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:43:44 $

% Get handles of associated packages and classes
hDeriveFromPackage = findpackage('estimator');
hDeriveFromClass   = findclass(hDeriveFromPackage, 'estimator');
hCreateInPackage   = findpackage('estimator');

% Construct class
c = schema.class(hCreateInPackage, 'patternsearch', hDeriveFromClass);

% Properties
