function this = TransientDataLeaf(parent, varargin)
% TRANSIENTDATALEAF Constructor for @TransientDataLeaf class

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.8 $ $Date: 2004/04/11 00:39:51 $

% Create class instance
this = spenodes.TransientDataLeaf;

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
this.Status = 'Select the tabbed panels to configure the transient data set.';
