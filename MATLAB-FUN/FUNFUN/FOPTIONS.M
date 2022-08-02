function OPTIONS=foptions(parain);
%FOPTIONS Default parameters used by the optimization routines.
%	In MATLAB itself:
%	    FMIN and FMINS.
%	In the Optimization Toolbox:
%	    FMINU, CONSTR, ATTGOAL, MINIMAX, LEASTSQ, FSOLVE.
%	The parameters are:
%	OPTIONS(1)-Display parameter (Default:0). 1 displays some results
%	OPTIONS(2)-Termination tolerance for X.(Default: 1e-4).
%	OPTIONS(3)-Termination tolerance on F.(Default: 1e-4).
%	OPTIONS(4)-Termination criterion on constraint violation.(Default: 1e-6)
%	OPTIONS(5)-Algorithm: Strategy:  Not always used.
%	OPTIONS(6)-Algorithm: Optimizer: Not always used. 
%	OPTIONS(7)-Algorithm: Line Search Algorithm. (Default 0)
%	OPTIONS(8)-Function value. (Lambda in goal attainment. )
%	OPTIONS(9)-Set to 1 if you want to check user-supplied gradients
%	OPTIONS(10)-Number of Function and Constraint Evaluations.
%	OPTIONS(11)-Number of Function Gradient Evaluations.
%	OPTIONS(12)-Number of Constraint Evaluations
%	OPTIONS(13)-Number of equality constraints. 
%	OPTIONS(14)-Maximum number of iterations. (Default 100*no. of variables)
%	OPTIONS(15)-Used in goal attainment for special objectives. 
%	OPTIONS(16)-Minimum change in variables for finite difference gradients.
%	OPTIONS(17)-Maximum change in variables for finite difference gradients.
%	OPTIONS(18)- Step length. (Default 1 or less). 

%	Andy Grace 7-9-90.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin<1; parain = []; end
sizep=length(parain);
OPTIONS=zeros(1,18);
OPTIONS(1:sizep)=parain(1:sizep);
default_options=[0,1e-4,1e-4,1e-6,0,0,0,0,0,0,0,0,0,0,0,1e-8,0.1,0];
OPTIONS=OPTIONS+(OPTIONS==0).*default_options;
