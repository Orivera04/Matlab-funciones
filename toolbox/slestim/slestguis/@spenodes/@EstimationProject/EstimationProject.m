function this = EstimationProject(parent, model, varargin)
% ESTIMATIONPROJECT  Constructor for @EstimationProject class

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.9 $ $Date: 2004/04/11 00:38:59 $

% Create class instance
this = spenodes.EstimationProject;

if nargin == 0
  % Call when reloading object
  return
end

% Check input arguments
if nargin > 2
  this.Label = varargin{1};
else
  this.Label = this.createDefaultName('Estimation Task', parent);
end

this.AllowsChildren = true;
this.Editable  = true;
this.Fields    = struct( 'Title',   '',  'Subject',     '', 'Author', '', ...
                         'Company', '',  'Description', '' );
this.Icon      = fullfile( 'toolbox', 'slestim', 'slestguis', ...
                           'resources', 'simulink_doc.gif' );
this.Model     = model;
this.Resources = 'com.mathworks.toolbox.slestim.resources.SPE_Menus_Toolbars';
this.Status    = 'Select the nodes below to configure and run estimations.';

% Add required components
%nodes = [ spenodes.TransientData(this); ...
%          spenodes.SteadyStateData(this); ...
%          spenodes.FrequencyData(this); ...
%          spenodes.Variables(this); ...
%          spenodes.Estimation(this); ...
%          spenodes.Validation(this) ];
nodes = [ spenodes.TransientData(this); ...
          spenodes.Variables(this); ...
          spenodes.Estimation(this); ...
          spenodes.Validation(this) ];
for i = 1:length(nodes)
  this.addNode( nodes(i) );
end
