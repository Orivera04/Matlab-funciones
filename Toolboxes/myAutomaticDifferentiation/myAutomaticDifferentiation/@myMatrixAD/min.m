function [x, y] = min(x)
% In Package myMatrixAD - Automatic Differentiation
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

% Many problems with this routine
% max neglects the derivative with respect to the time at the moment
% idx has to be rescaled after the output idx = idx.*diff(t(1:2));
%
% Overall it's a rough approx at the moment, but better than nought.

if nargout < 2
    x = max(-x);
else
    [x, y] = max(-x);
end
