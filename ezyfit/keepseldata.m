function keepseldata
%KEEPSELDATA  Delete points outside a polygon
%   KEEPSELDATA selects part of the current curve by drawing a polygon, and
%   deletes all the points that are outside the polygon (this operation is
%   irreversible). Press a key to escape.
%
%   KEEPSELDATA is a shortcut for SELECTDATA(gco,'keep').
%
%   See also DELSELDATA, SELECTDATA, PICKDATA, SELECTFIT.

%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.00,  Date: 2005/11/02
%   This function is part of the EzyFit Toolbox

% History:
% 2005/11/02: v1.00, fitst version

selectdata(gco,'keep');
