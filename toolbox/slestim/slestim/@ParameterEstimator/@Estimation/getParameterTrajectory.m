function s = getParameterTrajectory(this)
% GETPARAMETERTRAJECTORY Returns an array of structures with fields
% NAME  the parameter name
% VALUE the value of the parameter at each iteration

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/16 22:21:51 $

s = struct( 'Name', get(this.Parameters, {'Name'}), 'Value', []);

% Get estimated elements from the parameter/state objects.
p = this.Parameters;
EstimInfo = this.EstimInfo;
iter = length( EstimInfo.Iteration );

offset = 0;

for ct = 1:length(p)
  pct = p(ct);
  e = find(pct.Estimated);
  len = length(e);

  % Initialize with current values
  s(ct).Value = repmat( pct.Value(:)', iter, 1);
  
  % Update with estimated values
  if (len > 0) && ~isempty(EstimInfo.Values)
    s(ct).Value(:,e) = EstimInfo.Values(:, offset+1:offset+len);
    offset = offset + len;
  end
end
