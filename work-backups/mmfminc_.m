function fe=mmfminc_(x,fun,k)
%MMFMINC_ Helper function for MMFMINC. (MM)
% MMFMINC_(X,FUN,K) is used by MMFMINC as the
% function to pass to FMINS for minimization.
%
% See also MMFMINC, FMINS, FEVAL.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 7/18/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

[f,g]=feval(fun,x);
g=g(:);
g=g.*(g>0);
fe=f + k*g.'*g;
