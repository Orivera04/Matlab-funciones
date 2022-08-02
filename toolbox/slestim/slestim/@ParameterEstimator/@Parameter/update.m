function update(this, value, varargin)
% UPDATE Re-initialize the properties
%
% Requires valid Name properties.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/11 00:42:45 $

ni = nargin;
if (ni == 1)
  try
    value = evalin('base', this.Name);
  catch
    error('Variable "%s" does not exist in the workspace.', this.Name)
  end
end
dims = size(value);

if ~isequal(dims, this.Dimensions)
  % Private properties
  this.Dimensions   = dims;
  this.Value        = value;

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
