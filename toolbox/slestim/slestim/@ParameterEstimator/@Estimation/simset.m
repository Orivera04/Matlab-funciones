function simset(this, varargin)
% Sets simulation options for Estimation object.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.1 $ $Date: 2004/04/04 03:41:57 $

try
  set( this.SimOptions, varargin{:} );
catch
  rethrow(lasterror)
end
