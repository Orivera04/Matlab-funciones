function node = createChild(this)
% CREATECHILD Return list of default child objects.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:39:26 $

% Create default child object of this class
node = spenodes.SteadyStateDataLeaf( this );
