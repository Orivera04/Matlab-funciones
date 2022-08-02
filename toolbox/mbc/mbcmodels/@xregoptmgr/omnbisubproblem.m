function [om, OK] = omnbisubproblem(om,Ctxt);
% omNBI. Create an options manager for NBI subproblem
%[om, OK] = omNBIsubproblem

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.6.1 $  $Date: 2004/02/09 07:56:54 $

% make a structure with all the necessary fields to be an optmgr

% adjust some of those fields
om.name = 'NBISubproblem';
om.RunFcn = @i_run;


% These options can be change by the optimisation manger's GUI setp
om= AddOption(om,'Display','none','none|iter|final','',1);
om= AddOption(om,'MaxFunEvals',100,{'int',[1 Inf]},'Maximum function evaluations',1);
om= AddOption(om,'MaxIter',20,{'int',[1 Inf]},'Maximum iterations',1);
om= AddOption(om,'TolFun',1e-4,{'numeric',[0 Inf]},'Function tolerance',1);
om= AddOption(om,'TolX',1e-4,{'numeric',[0 Inf]},'Variable tolerance',1);
om= AddOption(om,'TolCon',1e-4,{'numeric',[0 Inf]},'Constraint tolerance',1);

% These options cannot be change by the optimisation manger's GUI setp
om= AddOption(om,'GradObj','on','on|off','',0);
om= AddOption(om,'GradConstr','off','on|off','',0);

OK = 1;


function varargout= i_run(Ctxt,om,x0,varargin);
% run function does nothing incase it is called

varargout= [{Ctxt,0,1},cell(1,max(0,nargout-3))];


function [f,g]= i_cost(x,varargin);

f= -x(end);
if nargout>1
    g= zeros(1,numel(x));
    g(end)=-1;
end
