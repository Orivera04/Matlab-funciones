function getTrajectory(this, r, varargin)
% Gets parameter trajectory data.

% Author(s): Bora Eryilmaz
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/16 22:20:52 $

h = this.Estimation;
d = r.Data;

% Look for visible+cleared responses in response array
if isempty( d.Values ) && strcmp( r.View.Visible, 'on' )
   % Regenerate data
   d.Iterations = h.EstimInfo.Iteration;
   if isempty(d.Iterations)
      d.Values = [];
      d.Focus = [0 10];
   else
      s = getParameterTrajectory(h);
      d.Values = {s.Value}';
      d.Focus = [0 max(10,ceil(d.Iterations(end)))];
   end
end
