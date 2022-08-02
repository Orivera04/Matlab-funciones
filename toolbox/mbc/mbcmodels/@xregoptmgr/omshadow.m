function [om, OK] = omshadow(om,Ctxt);
% omShadow. Create an options manager for Shadow subproblem
%[om, OK] = omShadow

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.6.1 $  $Date: 2004/02/09 07:56:55 $

% make a structure with all the necessary fields to be an optmgr

% adjust some of those fields
om.name = 'Shadow';
% doesn't run
om.RunFcn = @i_run;

% These options can be changed by the optimisation manger's GUI setp
om= AddOption(om,'Display','none','none|iter|final','',1);
om= AddOption(om,'MaxFunEvals',100,{'int',[1 Inf]},'Maximum function evaluations',1);
om= AddOption(om,'MaxIter',20,{'int',[1 Inf]},'Maximum iterations',1);
om= AddOption(om,'TolFun',1e-4,{'numeric',[0 Inf]},'Function tolerance',1);
om= AddOption(om,'TolX',1e-4,{'numeric',[0 Inf]},'Variable tolerance',1);
om= AddOption(om,'TolCon',1e-4,{'numeric',[0 Inf]},'Constraint tolerance',1);

% These options cannot be changed by the optimisation manger's GUI setup
om= AddOption(om,'GradObj','off','on|off','',0);
om= AddOption(om,'GradConstr','off','on|off','',0);
OK = 1;

function varargout= i_run(Ctxt,om,x0,varargin);
% run function does nothing incase it is called

varargout= [{Ctxt,0,1},cell(1,max(0,nargout-3))];
