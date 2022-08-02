function [LB,UB,A,b,nlcon,optparams]= constraints(m,X,Y);
% MODEL/CONSTRAINTS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:51:37 $


% upper and lower bounds for model
LB=[];
UB=[];

% linear constraints
A=[];
b=[];

% nonlinear constraints
nlcon= 0;

% optimisation parameters
optparams=[];