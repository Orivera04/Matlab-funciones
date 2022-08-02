function this = Estimation(parent, varargin)
% ESTIMATION Constructor for @Estimation class

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.6 $ $Date: 2004/04/11 00:38:32 $

% Create class instance
this = spenodes.Estimation;

if nargin == 0
  % Call when reloading object
  return
end

if nargin > 1
  this.Label = varargin{1};
else
  this.Label = 'Estimation';
end

this.AllowsChildren = true;
this.Editable = false;
this.Icon   = fullfile( 'toolbox', 'slestim', 'slestguis', ...
                        'resources', 'estimation_folder.gif' );
this.Status = 'Estimation node.';

% Add required components
nodes = [ spenodes.Viewer(this) ];
for i = 1:size(nodes,1)
  this.addNode(nodes(i));
end
