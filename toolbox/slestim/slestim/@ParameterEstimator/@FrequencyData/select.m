function h = select(this, type, varargin)
% SELECT Extract a subset of the data from the object
%
% hout = select(hin, 'Range',  [Fmin Fmax])
% hout = select(hin, 'Samples', Nstart:Nfinal)

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:42:30 $

h = this.copy;

if strncmpi(type, 'Range', 3)
  h = LocalRangeSelection( h, varargin{1} );
elseif strncmpi(type, 'Samples', 3)
  h = LocalSamplesSelection( h, varargin{1} );
else
  error('Invalid selection method.')
end

% --------------------------------------------------------------------------
function h = LocalRangeSelection(h, range)
indices = find(h.Frequency >= range(1) & h.Frequency <= range(end));
freq    = h.Frequency;

% Restore from "freq"
h.Data = h.getDataAtIndex(indices);
h.Frequency = freq(indices);

% --------------------------------------------------------------------------
function h = LocalSamplesSelection(h, samples)
indices = samples;
freq    = h.Frequency;

% Restore from "freq"
h.Data = h.getDataAtIndex(indices);
h.Frequency = freq(indices);
