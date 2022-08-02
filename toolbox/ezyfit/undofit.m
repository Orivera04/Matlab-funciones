function undofit
%UNDOFIT  Remove the last fit from the current figure
%   UNDOFIT removes the last fit (and its equation box) created by
%   SHOWFIT or SELECTFIT from the current figure.
%
%   UNDOFIT is a shortcut for RMFIT('last').
%
%   See also SHOWFIT, SELECTFIT, RMFIT, EFMENU.

%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.00,  Date: 2005/10/31
%   This function is part of the EzyFit Toolbox

rmfit('last');
