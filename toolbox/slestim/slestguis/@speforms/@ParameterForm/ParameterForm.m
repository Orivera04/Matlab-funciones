function this = ParameterForm(h)
% PARAMETERFORM Constructor

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:38:14 $

% Create class instance
this = speforms.ParameterForm;

ni = nargin;
if ni == 0
  % Call when reloading object
  return
end

% Initialize
this.Name         = h.Name;
this.Dimensions   = h.Dimensions;

this.Value        = mat2str(h.Value, 5);
this.InitialGuess = h.Name; % mat2str(h.InitialGuess, 5);
this.Minimum      = '-Inf'; % mat2str(h.Minimum, 5);
this.Maximum      = '+Inf'; % mat2str(h.Maximum, 5);
this.TypicalValue = h.Name; % mat2str(h.TypicalValue, 5);

this.Estimated    = 'false';
this.ReferencedBy = h.ReferencedBy;
this.Description  = h.Description;
