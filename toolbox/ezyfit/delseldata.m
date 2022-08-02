function delseldata
%DELSELDATA  Delete points inside a polygon
%   DELSELDATA selects part of the current curve by drawing a lasso, and
%   deletes all the points that are inside the polygon (this operation is
%   irreversible). 
%
%   DELSELDATA is a shortcut for SELECTDATA('delete').
%
%   See also SELECTDATA, PICKDATA, SELECTFIT.

%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.10,  Date: 2007/09/19
%   This function is part of the EzyFit Toolbox

% History:
% 2005/11/02: v1.00, fitst version
% 2007/09/19: v1.10, now based on D'Errico's selecdata

h=gco;
listhandle=get(gca, 'Children');
ignorehandle=listhandle(listhandle~=h);
selectdata('action','delete','ignore',ignorehandle);

