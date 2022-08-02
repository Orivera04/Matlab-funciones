function this = FrequencyData(parent, varargin)
% FREQUENCYDATA Constructor for @FrequencyData class

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:39:05 $

% Create class instance
this = spenodes.FrequencyData;

if nargin == 0
  % Call when reloading object
  return
end

% Check input arguments
if nargin > 1
  this.Label = varargin{1};
else
  this.Label = 'Frequency Data';
end

this.AllowsChildren = true;
this.Editable = false;
this.Icon     = fullfile( 'toolbox', 'slestim', 'slestguis', ...
                          'resources', 'data_folder.gif' );
this.Status   = [ 'Frequency data sets are stored in this folder. ', ...
                  'Press ''New'' to create a new data set' ];
