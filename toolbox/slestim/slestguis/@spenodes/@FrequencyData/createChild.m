function node = createChild(this)
% CREATECHILD Return list of default child objects.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:39:06 $

% Create default child object of this class
node = spenodes.FrequencyDataLeaf( this );
