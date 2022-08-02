function verify(this)
% VERIFY Verify data compatibility
%
% Requires valid Block properties.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.1 $ $Date: 2003/12/22 00:57:09 $

try
  value = evalin('base', this.Name);
catch
  error('Variable %s does not exist in the workspace.', this.Name)
end

% Value from workspace might not be numeric
if ~isnumeric(value)
  error('Variable %s is not a numeric variable.', name)
end
dims = size(value);

if ~isequal(dims, this.Dimensions)
  error('Parameter dimensions changed in ''%s'' block.', this.Block)
end
