function this = ViewerLeaf(parent, varargin)
% VIEWERLEAF Constructor for @Estimation class

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.6 $ $Date: 2004/04/11 00:40:41 $

% Create class instance
this = spenodes.ViewerLeaf;

if nargin == 0
  % Call when reloading object
  return
end

if nargin > 1
  this.Label = varargin{1};
else
  this.Label = this.createDefaultName('New View', parent);
end

this.Fields = struct('Plots',   [], ...
                     'Options', []);
this.Icon = fullfile( 'toolbox', 'slestim', 'slestguis', ...
                      'resources', 'views.gif' );
this.Status = 'Configure dynamic views.';
