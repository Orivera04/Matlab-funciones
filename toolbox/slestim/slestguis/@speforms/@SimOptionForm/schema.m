function schema
% SCHEMA 

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:38:17 $

% Get handles of associated packages and classes
hDeriveFromPackage = findpackage('slcontrol');
hDeriveFromClass   = findclass(hDeriveFromPackage, 'SimOptionForm');
hCreateInPackage   = findpackage('speforms');

% Construct class
c = schema.class(hCreateInPackage, 'SimOptionForm', hDeriveFromClass);

% Properties
