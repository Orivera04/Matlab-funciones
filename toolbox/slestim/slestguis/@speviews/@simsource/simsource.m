function this = simsource(Estimation)
% Constructor

% Author(s): Bora Eryilmaz
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/16 22:21:41 $

this = speviews.simsource;
if nargin > 0
  % Link to estimation object
  this.Estimation = Estimation;
  this.OutputPort = getPortHandles(Estimation.Experiments);
  
  % Add listeners
  addlisteners(this)
end
