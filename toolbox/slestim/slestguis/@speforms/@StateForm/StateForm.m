function this = StateForm(h)
% STATE Constructor for @State class

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/11 00:38:18 $

% Create class instance
this = speforms.StateForm;

ni = nargin;
if ni == 0
  % Call when reloading object
  return
end

% Initialize
this.Block        = h.Block;
this.Dimensions   = h.Dimensions;

this.Value        = mat2str(h.Value, 5);
this.InitialGuess = mat2str(h.InitialGuess, 5);
this.Minimum      = '-Inf'; % mat2str(h.Minimum, 5);
this.Maximum      = '+Inf'; % mat2str(h.Maximum, 5);
this.TypicalValue = mat2str(h.TypicalValue, 5);

this.Estimated    = 'false';
this.Ts           = mat2str(h.Ts, 5);
this.Domain       = h.Domain;
this.Description  = h.Description;
