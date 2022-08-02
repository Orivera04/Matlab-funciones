function schema
% SCHEMA Defines class properties

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:40:40 $

% Find parent package
pkg = findpackage('explorer');

% Find parent class (superclass)
supclass = findclass(pkg, 'node');

% Register class (subclass) in package
inpkg = findpackage('spenodes');
c = schema.class(inpkg, 'Viewer', supclass);

% Properties
