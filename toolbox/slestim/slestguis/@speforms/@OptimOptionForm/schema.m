function schema
% SCHEMA Literal specification of optimization options for SPE projects.

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:38:13 $

% Get handles of associated packages and classes
hDeriveFromPackage = findpackage('slcontrol');
hDeriveFromClass   = findclass(hDeriveFromPackage, 'OptimOptionForm');
hCreateInPackage   = findpackage('speforms');

% Construct class
c = schema.class(hCreateInPackage, 'OptimOptionForm', hDeriveFromClass);

% Add new enumeration type
if isempty( findtype('speforms_Algorithm') )
  schema.EnumType( 'speforms_Algorithm', ...
                   {'fmincon', 'lsqnonlin', 'patternsearch', 'fminsearch'} );
end

if isempty( findtype('speforms_CostType') )
  schema.EnumType( 'speforms_CostType', {'SSE', 'SAE'} );
end

% Properties
p = schema.prop(c,'Algorithm', 'speforms_Algorithm');
p.FactoryValue = 'lsqnonlin';

p = schema.prop(c, 'CostType', 'speforms_CostType');
p.FactoryValue = 'SSE';

p = schema.prop(c, 'DiffMaxChange', 'string');
p.FactoryValue = '1.0e-1';

p = schema.prop(c, 'DiffMinChange', 'string');
p.FactoryValue = '1.0e-8';

p = schema.prop(c, 'MaxFunEvals', 'string');
p.FactoryValue = '400';

p = schema.prop(c, 'RobustCost', 'on/off');
p.FactoryValue = 'off';
