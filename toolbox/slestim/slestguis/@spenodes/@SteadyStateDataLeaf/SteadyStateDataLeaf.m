function this = SteadyStateDataLeaf(parent, varargin)
% STEADYSTATEDATALEAF Constructor for @SteadtStateDataLeaf class

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.8 $ $Date: 2004/04/11 00:39:31 $

% Create class instance
this = spenodes.SteadyStateDataLeaf;

if nargin == 0
  % Call when reloading object
  return
end

% Check input arguments
if nargin > 1
  this.Label = varargin{1};
else
  this.Label = this.createDefaultName('New Data', parent);
end

this.Icon   = fullfile( 'toolbox', 'slestim', 'slestguis', ...
                        'resources', 'data.gif' );
this.Status = 'Select the tabbed panels to configure the steady-state data set.';
