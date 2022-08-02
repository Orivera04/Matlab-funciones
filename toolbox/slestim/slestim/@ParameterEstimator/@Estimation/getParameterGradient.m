function s = getParameterGradient(this)
% GETPARAMETERGRADIENT Returns an array of structures with fields
% NAME  the parameter name
% VALUE the value of the parameter gradient at each iteration

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.8.3 $ $Date: 2004/04/16 22:21:50 $

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
  s(ct).Value = repmat( 0, iter, length( pct.Value(:)) );
  
  % Update with estimated values
  if (len > 0) && ~isempty(EstimInfo.Gradient)
    s(ct).Value(:,e) = EstimInfo.Gradient(:, offset+1:offset+len);
    offset = offset + len;
  end
end
