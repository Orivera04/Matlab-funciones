function Xp=mmlsim_(t,x)
%MMLSIM_ Helper Function for MMLSIM. (MM)
% Xp=MMLSIM_(T,X) returns the state derivatives of a linear
% system  .
%         x = Ax + Bu
%
% A, B and u are passed by global variables from MMLSIM.
%
% See also MMLSIM.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 9/11/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

global MMLSIM_A MMLSIM_BU

Xp=MMLSIM_A*x(:) + MMLSIM_BU;
