function verify(this)
% VERIFY Verify data compatibility
%
% Requires valid Block, PortType, and PortNumber properties.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.1 $ $Date: 2003/12/22 00:57:42 $

dims = this.getCompiledDimensions;

if ~isequal(dims, this.Dimensions)
  error('Signal dimensions changed in ''%s'' block.', this.Block);
end

if this.getDataLength ~= length(this.Time)
  error('Time vector length is incompatible with the number of Data samples.')
end
