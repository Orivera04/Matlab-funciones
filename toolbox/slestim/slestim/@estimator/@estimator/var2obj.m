function var2obj(this, x)
% VAR2OBJ Converts estimation variable data back into parameter/state data.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/11 00:43:27 $

offset = 0;
p = [this.Estimation.Parameters; this.Estimation.States(:)];

% Set estimated elements of parameter/state objects from the vector X.
for ct = 1:length(p)
  pct  = p(ct);
  idxs = find(pct.Estimated);
  len  = length(idxs);
  
  if len > 0
    pct.Value(idxs) = x(offset+1:offset+len);
    offset = offset + len;
  end
end
