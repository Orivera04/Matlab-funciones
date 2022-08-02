function update(this, value, varargin)
% UPDATE Re-initialize the properties
%
% Requires valid Block property.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.6 $ $Date: 2004/04/11 00:42:50 $

ni = nargin;
if (ni == 1)
  util = slcontrol.Utilities;
  hModel = getModelHandleFromBlock(util, this.Block);
  model  = hModel.getFullName;

  info  = evalStates(util, model, {this.Block});
  value = info.Value;
  Ts    = info.Ts;
  dims  = size(value);
else
  Ts    = 0.0;
  dims  = size(value);
end

if ~isequal(dims, this.Dimensions)
  % Private properties
  this.Dimensions = dims;
  this.Value      = value;
  this.Ts         = Ts;

  % Public properties
  this.Estimated    = false( this.Dimensions );
  this.InitialGuess = this.Value;
  this.Minimum      = -Inf * ones( this.Dimensions );
  this.Maximum      = +Inf * ones( this.Dimensions );
  this.TypicalValue = this.Value;
  this.Description  = '';
end

% Set properties
set( this, varargin{:} );
