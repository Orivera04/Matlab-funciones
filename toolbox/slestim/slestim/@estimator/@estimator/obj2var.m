function var = obj2var(this)
% OBJ2VAR Serializes estimated parameter/state object data into estimation
% variable data for optimizers. 

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:43:24 $

x0 = [];
lb = [];
ub = [];
Sx = [];

% Get estimated elements from the parameter/state objects.
p = [this.Estimation.Parameters; this.Estimation.States(:)];

for ct = 1:length(p)
  pct = p(ct);
  e = find(pct.Estimated);
  
  if ~isempty(e)
    val = pct.InitialGuess(e);
    x0 = [ x0 ; val(:) ];

    val = pct.Minimum(e);
    lb = [ lb ; val(:) ];
    
    val = pct.Maximum(e);
    ub = [ ub ; val(:) ];

    val = pct.TypicalValue(e);
    Sx = [ Sx ; val(:) ];
  end
end

% Parameter information structure
var = struct( 'Initial', x0, ...
              'Minimum', lb, ...
              'Maximum', ub, ...
              'Typical', Sx );
