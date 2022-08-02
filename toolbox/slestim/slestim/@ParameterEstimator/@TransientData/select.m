function h = select(this, type, varargin)
% SELECT Extract a subset of the data from the object
%
% hout = select(hin, 'Range',  [Tmin Tmax])
% hout = select(hin, 'Samples', Nstart:Nfinal)

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:43:10 $

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
indices = find(h.Time >= range(1) & h.Time <= range(end));
time    = h.Time;

% Restore from "time", since setting Data will change Time vector when Ts is set.
h.Data = h.getDataAtIndex(indices);
h.Time = time(indices);

% --------------------------------------------------------------------------
function h = LocalSamplesSelection(h, samples)
indices = samples;
time    = h.Time;

% Restore from "time", since setting Data will change Time vector when Ts is set.
h.Data = h.getDataAtIndex(indices);
h.Time = time(indices);
