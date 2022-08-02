function [om, OK] = omNBI(om,Context)
% omNBI. Create an options manager for NBI, a Multi-Objective Genetic algorithm. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.6.1 $  $Date: 2004/02/09 07:56:53 $

%[om, OK] = omNBI

% make a structure with all the necessary fields to be an optmgr

% adjust some of those fields
om.name = 'Normal Boundary Intersection';

om.RunFcn = @i_runnbi;

%make an optmgr from it 

om = AddOption(om,'NumberOfPoints',10,{'int',[2 Inf]}, 'Tradeoff points per objective pair');
om = AddOption(om,'ShadowOptions',omshadow(xregoptmgr,Context),'xregoptmgr', 'Shadow minima options');
om = AddOption(om,'NBISubproblemOptions',omnbisubproblem(xregoptmgr,Context),'xregoptmgr', 'NBI subproblem options');

OK = 1;

function [cos,Fmat,OK,Xmat,OUTPUT] = i_runnbi(cos,omNBI,x0,varargin)

OK=1;
NBIoptions = om2options(omNBI);

[LB,UB,A,C,nlconfun]= getConstraints(omNBI);

NumberOfPoints     = get(omNBI,'NumberOfPoints');
NumberOfObjectives = get(cos,'NumberOfObjectives');

% call main 
[Xmat,Fmat,EXITFLAG,OUTPUT] = cgnbi(omNBI.costFcn,x0,NumberOfObjectives, NumberOfPoints,A,B,[], [], LB, UB, nlconfun, NBIoptions,cos, varargin{:});


function options = om2options(NBIom)

% take an NBI om and return an NBI options structure

ShadowOm = get(NBIom, 'ShadowOptions');
NBISubproblemOm = get(NBIom, 'NBISubproblemOptions');

NBIoptions = NBI('defaults');
ShadowOptions = NBIoptions.ShadowOptions;
NBISubproblemOptions = NBIoptions.NBISubproblemOptions;

ShadowOptions= optimset(ShadowOptions, ...
    'Display', get(ShadowOm ,'Display'),...
    'GradObj',get(ShadowOm ,'GradObj'),...
    'GradConstr',get(ShadowOm ,'GradConstr'),...
    'MaxFunEvals',get(ShadowOm ,'MaxFunEvals'),...
    'MaxIter',get(ShadowOm ,'MaxIter'),...
    'TolFun', get(ShadowOm ,'TolFun'),...
    'TolX', get(ShadowOm ,'TolX'),...
    'TolCon', get(ShadowOm ,'TolCon'));

NBISubproblemOptions= optimset(NBISubproblemOptions, ...
    'Display', get(NBISubproblemOm ,'Display'),...
    'GradObj',get(NBISubproblemOm ,'GradObj'),...
    'GradConstr',get(NBISubproblemOm ,'GradConstr'),...
    'MaxFunEvals',get(NBISubproblemOm ,'MaxFunEvals'),...
    'MaxIter',get(NBISubproblemOm ,'MaxIter'),...
    'TolFun', get(NBISubproblemOm ,'TolFun'),...
    'TolX', get(NBISubproblemOm ,'TolX'),...
    'TolCon', get(NBISubproblemOm ,'TolCon'));

options = NBIoptimset(ShadowOptions, NBISubproblemOptions);
