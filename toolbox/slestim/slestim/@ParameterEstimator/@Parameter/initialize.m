function initialize(this, name)
% INITIALIZE Initialize object properties
%
% NAME is the name of the parameter.

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:42:43 $

% Check parameter name
if ~ischar(name)
  error('A parameter name should be provided as the first argument.')
end

% Set private properties
this.Name = name;
