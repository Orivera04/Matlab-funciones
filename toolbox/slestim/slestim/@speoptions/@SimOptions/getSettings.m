function s = getSettings(this)
% Gets settings applicable to simulation.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.1 $ $Date: 2004/01/03 12:27:02 $

s = get(this);  
s = rmfield( s, {'StartTime', 'StopTime'} );
