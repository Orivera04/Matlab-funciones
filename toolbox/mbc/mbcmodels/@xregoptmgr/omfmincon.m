function [om, OK] = omfmincon(om,Ctxt);
% omfmincon. Create an options manager for fmincon

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.6.1 $  $Date: 2004/02/09 07:56:52 $

%[om, OK] = omfmincon


% adjust some of those fields
om.name = 'fmincon';
om.RunFcn = @i_Evaluate;

%make an optmgr from it 
om = xregoptmgr(om);

% These options can be changed by the optimisation manger's GUI setp
om= AddOption(om,'Display','none','none|iter|final','',1);
om= AddOption(om,'MaxFunEvals',1000,{'int',[1 Inf]},'Maximum function evaluations',1);
om= AddOption(om,'MaxIter',100,{'int',[1 Inf]},'Maximum iterations',1);
om= AddOption(om,'TolFun',1e-6,{'numeric',[1e-12 Inf]},'Function tolerance',1);
om= AddOption(om,'TolX',1e-6,{'numeric',[1e-12 Inf]},'Variable tolerance',1);
om= AddOption(om,'TolCon',1e-6,{'numeric',[1e-12 Inf]},'Constraint tolerance',1);

% These options cannot be changed by the optimisation manger's GUI setup
om= AddOption(om,'GradObj','off','on|off','',0);
om= AddOption(om,'GradConstr','off','on|off','',0);

OK = 1;

function [optimstore, OUTPUT, OK, xsolution] = i_Evaluate(optimstore, om, x0,varargin);
%------------------------------------------------------------------
OK = 1;
errormessage = '';

% make options structure
options = fmincon_om2options(om);

[LB,UB,A,C,nlconfun]= getConstraints(om);

[xsolution, notused1, notused2, OUTPUT] = fmincon(om.costFcn, x0, A, B, [],[], LB, UB, nlconfun, options, optimstore, varargin{:});






function options = fmincon_om2options(om)
% take an fmincon om and return an fmincon options structure

options = fmincon('defaults');

options= optimset(options, ...
    'Display', get(om ,'Display'),...
    'GradObj',get(om ,'GradObj'),...
    'GradConstr',get(om ,'GradConstr'),...
    'MaxFunEvals',get(om ,'MaxFunEvals'),...
    'MaxIter',get(om ,'MaxIter'),...
    'TolFun', get(om ,'TolFun'),...
    'TolX', get(om ,'TolX'),...
    'TolCon', get(om ,'TolCon'));



