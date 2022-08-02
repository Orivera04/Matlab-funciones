function initialize(this, block)
% INITIALIZE Initialize object properties
%
% BLOCK is a Simulink block name or handle.

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/11 00:42:54 $

% Get Simulink object corresponding to block
util = slcontrol.Utilities;
h    = getBlockHandle(util, block);

% Set private properties
this.Block  = h.getFullName;
this.Domain = LocalDomain(this, h);

% -----------------------------------------------------------------------------
function Domain = LocalDomain(this, h)
if any( strcmp(h.fieldnames, 'PhysicalDomain') )
  Domain = h.PhysicalDomain;
else
  Domain = '';
end
