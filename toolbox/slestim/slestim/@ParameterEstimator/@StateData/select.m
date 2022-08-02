function h = select(this, type, varargin)
% SELECT Extract a subset of the data from the object
%
% hout = select(hin, 'Samples', Nstart:Nfinal)

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:42:56 $

h = this.copy;

if strncmpi(type, 'Samples', 3)
  h = LocalSamplesSelection( h, varargin{1} );
else
  error('Invalid selection method.')
end

% --------------------------------------------------------------------------
function h = LocalSamplesSelection(h, samples)
indices = samples;
h.Data = h.Data(indices,:);
