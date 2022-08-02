function update(this, dims, varargin)
% UPDATE Re-initialize the properties
%
% Requires valid Block, PortType, and PortNumber properties.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.1 $ $Date: 2003/12/22 00:57:29 $

% REM: Will compile the model.
ni = nargin;
if (ni == 1)
  dims = this.getCompiledDimensions;
end

if ~isequal(dims, this.Dimensions)
  % Private properties
  this.Dimensions = dims;

  % Public properties
  this.Data   = [];
  this.Weight =  1;
  this.Description = '';
end

% Set properties
set( this, varargin{:} );
