function spetool( model )
% SPETOOL Launches the Simulink Parameter Estimation GUI
%
% This function launches the Simulink Parameter Estimation tool with a
% project created for the Simulink MODEL supplied as the first argument.

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:44:02 $

if (nargin == 0) || ~isa(model, 'char')
  error('A model name is required as the first argument.')
end

try
  slparamestim('initialize', model);
catch
  error('Invalid model name %s.', model)
end
