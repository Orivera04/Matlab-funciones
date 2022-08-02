function this = Viewer(parent, varargin)
% VIEWER Constructor for @viewer class

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.6 $ $Date: 2004/04/11 00:40:35 $

% Create class instance
this = spenodes.Viewer;

if nargin == 0
  % Call when reloading object
  return
end

if nargin > 1
  this.Label = varargin{1};
else
  this.Label = 'Views';
end

this.AllowsChildren = true;
this.Status = 'Viewer node.';
this.Editable = false;
this.Icon = fullfile( 'toolbox','slestim','slestguis', ...
                      'resources','views_folder.gif' );
