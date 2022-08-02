function this = EstimationLeaf(parent, varargin)
% ESTIMATIONLEAF Constructor for @EstimationLeaf class

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.9 $ $Date: 2004/04/11 00:38:39 $

% Create class instance
this = spenodes.EstimationLeaf;

if nargin == 0
  % Call when reloading object
  return
end

% Check input arguments
if nargin > 1
  this.Label = varargin{1};
else
  this.Label = this.createDefaultName('New Estimation', parent);
end

this.Fields = struct( 'PlotsCheckBox', false );
this.Icon   = fullfile( 'toolbox', 'slestim', 'slestguis', ...
                        'resources', 'estimation.gif' );
this.Status = 'Configure your estimation here.';
