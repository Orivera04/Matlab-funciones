function getCost(this, r, varargin)
% COST Update cost function data

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/04/04 03:41:27 $

h = this.Estimation;
d = r.Data;

if isempty( d.Amplitude ) && strcmp( r.View.Visible, 'on' )
  % Regenerate data
  d.Time = h.EstimInfo.Iteration;
  if isempty(d.Time)
    d.Amplitude = [];
    d.Focus = [0 1];
  else
    d.Amplitude = h.EstimInfo.Cost;
    d.Focus = [0 ceil(d.Time(end))];
  end
end
