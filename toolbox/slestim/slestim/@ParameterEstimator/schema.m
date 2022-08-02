function schema
% SCHEMA Package definition

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:43:17 $

schema.package('ParameterEstimator');

% Define enumerated string types
% Hold type for @TransientIOData objects
if isempty( findtype('HoldType') )
  schema.EnumType( 'HoldType', {'zoh', 'foh'} );
end

% Port type for @Transient/@SteadyStateIOData objects
if isempty( findtype('PortType') )
  schema.EnumType( 'PortType', {'Inport', 'Outport', 'Signal'} );
end
