function schema
% SCHEMA Defines properties for @lsqnonlin class

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:43:40 $

% Get handles of associated packages and classes
hDeriveFromPackage = findpackage('estimator');
hDeriveFromClass   = findclass(hDeriveFromPackage, 'estimator');
hCreateInPackage   = findpackage('estimator');

% Construct class
c = schema.class(hCreateInPackage, 'lsqnonlin', hDeriveFromClass);

% Properties
