function this = ValidationLeaf(parent, varargin)
% VALIDATIONLEAF Constructor for @Estimation class

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.7 $ $Date: 2004/04/11 00:40:14 $

% Create class instance
this = spenodes.ValidationLeaf;

if nargin == 0
  % Call when reloading object
  return
end

if nargin > 1
  this.Label = varargin{1};
else
  this.Label = this.createDefaultName('New Validation', parent);
end

this.Fields = struct('Plots',   [], ...
                     'Options', []);
this.Icon = fullfile( 'toolbox', 'slestim', 'slestguis', ...
                      'resources', 'validation.gif' );
this.Status = 'Configure validation plots.';
