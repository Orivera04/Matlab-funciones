function str = maketip(this,tip,info)
% MAKETIP Build data tips for @costview curves.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.4.1 $ $Date: 2004/04/16 22:20:48 $

r = info.Carrier;
str = { sprintf('Iteration: %d', floor(tip.Position(1))) ; ...
        sprintf('Cost: %0.3g',         tip.Position(2)) };
