function delseldata
%DELSELDATA  Delete points inside a polygon
%   DELSELDATA selects part of the current curve by drawing a polygon, and
%   deletes all the points that are inside the polygon (this operation is
%   irreversible). Press a key to escape.
%
%   DELSELDATA is a shortcut for SELECTDATA(gco,'del').
%
%   See also KEEPSELDATA, SELECTDATA, PICKDATA, SELECTFIT.

%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.00,  Date: 2005/11/02
%   This function is part of the EzyFit Toolbox

% History:
% 2005/11/02: v1.00, fitst version

selectdata(gco,'del');

