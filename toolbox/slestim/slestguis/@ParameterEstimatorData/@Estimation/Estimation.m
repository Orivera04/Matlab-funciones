function this = Estimation(varargin)
% ESTIMATION Constructor for @estimation class
%
% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:37:30 $

% Create class instance
this = speguidata.estimation;

if (nargin > 0)
  h = varargin{1};
end

if isa(h, 'slestim.portdata')
  sizes = mat2str( h.Dimensions );
  sizes = strrep(sizes, ' ', ' x ');
  sizes = strrep(sizes, '[', '');
  sizes = strrep(sizes, ']', '');
  
  set(this, 'Name', h.Name, ...
            'Dimensions', sizes, ...
            'Data', mat2str(h.Data), ...
            'Units', h.Units);
end
