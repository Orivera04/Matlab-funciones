function varargout = evalForm(this, h)
% EVALFORM Evaluates literal state settings in appropriate workspace
% and returns a @StateData object with all-numeric values.

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:37:41 $

for k = 1:prod(this.Dimensions)
  % Get data from the stored value
  dataval = this.DataVal{k};
  
  try
    Data(:,k) = dataval(:);
  catch
    error('Data specified at row %d for block %s does not match the previous rows', ...
          k, this.Block);
  end
end

try 
  h.Data = Data;
catch
  error( 'Invalid data for block %s.\n%s', ...
         regexprep(this.Block, '\n\r?', ' '), lasterr )
end

if nargout > 0
  varargout{1} = h;
end
