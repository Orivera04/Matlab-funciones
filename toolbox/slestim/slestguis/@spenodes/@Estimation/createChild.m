function node = createChild(this)
% CREATECHILD Return list of required component names.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:38:34 $

% Define list of required components for objects of this class
node = spenodes.EstimationLeaf(this);
