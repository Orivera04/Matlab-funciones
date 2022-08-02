function this = SteadyStateData(parent, varargin)
% STEADYSTATEDATA Constructor for @SteadyStateData class

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.7 $ $Date: 2004/04/11 00:39:25 $

% Create class instance
this = spenodes.SteadyStateData;

if nargin == 0
  % Call when reloading object
  return
end

% Check input arguments
if nargin > 1
  this.Label = varargin{1};
else
  this.Label = 'Steady-State Data';
end

this.AllowsChildren = true;
this.Editable = false;
this.Icon     = fullfile( 'toolbox', 'slestim', 'slestguis', ...
                          'resources', 'data_folder.gif' );
this.Status   = [ 'Steady-State data sets are stored in this folder. ', ...
                  'Press ''New'' to create a new data set' ];
