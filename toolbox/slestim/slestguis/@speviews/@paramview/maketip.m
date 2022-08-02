function str = maketip(this, tip, info)
% MAKETIP Build data tips for @paramview curves.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/16 22:20:57 $

r = info.Carrier;
str = { this.rcinfo(r, info.Row, info.Col, tip.Host); ...
        sprintf('Iteration: %d', floor(tip.Position(1))); ...
        sprintf('Value: %0.3g',        tip.Position(2)) };
