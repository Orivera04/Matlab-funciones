function this = Variables(parent, varargin)
% VARIABLES Constructor for @Variables class

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.6 $ $Date: 2004/04/11 00:40:25 $

% Create class instance
this = spenodes.Variables;

if nargin == 0
  % Call when reloading object
  return
end

% Check input arguments
if nargin > 1
  this.Label = varargin{1};
else
  this.Label = 'Variables';
end

this.AllowsChildren = false;
this.Editable = false;
this.Icon     = fullfile( 'toolbox', 'slestim', 'slestguis', ...
                          'resources', 'variables_folder.gif' );
this.Status   = 'Configure here your parameters and states to estimate.';
