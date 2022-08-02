function verify(this)
% VERIFY Verify data compatibility
%
% Requires valid Block properties.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:42:58 $

util = slcontrol.Utilities;
hModel = getModelHandleFromBlock(util, this.Block);
model  = hModel.getFullName;

info = evalStates(util, model, {this.Block});
dims = size(info.Value);
  
if ~isequal(dims, this.Dimensions)
  error('State dimensions changed in ''%s'' block.', this.Block);
end
