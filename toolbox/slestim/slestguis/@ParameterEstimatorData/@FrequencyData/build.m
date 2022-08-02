function varargout = build(this, h)
% BUILD Configure the object H using the data stored in THIS.

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/11 00:37:33 $

for k = 1:prod(this.Dimensions)
  % Get data from the stored value
  dataval = this.DataVal{k};
  
  try
    Data(:,k)   = dataval(:);
    Weight(:,k) = evalin( 'base', this.Weight{k}, '0' );
  catch
    error('Data specified at row %d for block %s does not match the previous rows', ...
          k, this.Block);
  end
end

% Get frequency from the stored value
Freq = this.FrequencyVal;

try
  h.Data = Data;
  if length(Freq) == 1
    h.Fs = Freq;
  else
    h.Frequency = Freq;
  end
  h.Weight = Weight;
catch
  error( 'Invalid data for block %s.\n%s', ...
         regexprep(this.Block, '\n\r?', ' '), lasterr )
end

if nargout > 0
  varargout{1} = h;
end
