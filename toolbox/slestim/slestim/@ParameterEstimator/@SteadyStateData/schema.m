function schema
% SCHEMA Defines class properties

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:43:00 $

% Get handles of associated packages and classes
hDeriveFromPackage = findpackage('ParameterEstimator');
hDeriveFromClass   = findclass(hDeriveFromPackage, 'IOData');
hCreateInPackage   = findpackage('ParameterEstimator');

% Construct class
c = schema.class(hCreateInPackage, 'SteadyStateData', hDeriveFromClass);
