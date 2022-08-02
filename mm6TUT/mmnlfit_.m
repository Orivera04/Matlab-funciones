function e=mmnlfit_(p,x,y,z,fun)
%MMNLFIT_ Helper function for MMNLFIT and MMNLFIT2. (MM)
% MMNLFIT_(P,X,Y,[],FUN) is used by MMNLFIT as the
% function to pass to FMINS for minimization.
% MMNLFIT_(P,X,Y,Z,FUN) is used by MMNLFIT2 as the
% function to pass to FMINS for minimization.
%
% See also MMNLFIT, MMNLFIT2, FMINS

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 7/14/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if isempty(z)
   e=y - feval(fun,x,p);
else
   e=z - feval(fun,x,y,p);
end
e=e(:);
e=e'*e;
