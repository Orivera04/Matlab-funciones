function setActivePlots(this)
% Show estimated parameters and hide remaining parameters.

% Author(s): P. Gahinet
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:41:24 $
isEstimated = isEstimatedParam(this);
if ~any(isEstimated)
   this.ChannelVisible(:) = {'on'};
else
   Vis = {'off';'on'};
   this.ChannelVisible = Vis(1+isEstimatedParam(this));
end
