function update(this, value, varargin)
% UPDATE Re-initialize the properties
%
% Requires valid Block property.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/11 00:42:57 $

ni = nargin;
if (ni == 1)
  util = slcontrol.Utilities;
  hModel = getModelHandleFromBlock(util, this.Block);
  model  = hModel.getFullName;

  info  = evalStates(util, model, {this.Block});
  value = []; 
  Ts    = info.Ts;
  dims  = size(info.Value);
else
  Ts    = 0.0;
  dims  = size(value);
end

if ~isequal(dims, this.Dimensions)
  % Private properties
  this.Dimensions = dims;
  this.Ts         = Ts;

  % Public properties
  this.Data        = value;
  this.Description = '';
end

% Set properties
set( this, varargin{:} );
