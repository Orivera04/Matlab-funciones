function this = Validation(parent, varargin)
%  VALIDATION onstructor for @validation class

%  Author(s): Bora Eryilmaz
%  Revised:
%  Copyright 1986-2004 The MathWorks, Inc.
%  $Revision: 1.1.6.6 $ $Date: 2004/04/11 00:40:08 $

% Create class instance
this = spenodes.Validation;

if nargin == 0
  % Call when reloading object
  return
end

if nargin > 1
  this.Label = varargin{1};
else
  this.Label = 'Validation';
end

this.Status = 'Validation node.';
this.AllowsChildren = true;
this.Editable = false;
this.Icon = fullfile( 'toolbox', 'slestim', 'slestguis', ...
                      'resources', 'validation_folder.gif' );
