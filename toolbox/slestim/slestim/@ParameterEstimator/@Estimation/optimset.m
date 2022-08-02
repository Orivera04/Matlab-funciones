function optimset(this, varargin)
% Sets optimization options for Estimation object.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.1 $ $Date: 2004/04/04 03:41:55 $

try
  set( this.OptimOptions, varargin{:} )
catch
  rethrow(lasterror)
end
