function F= genetic(F,m);
% FITALGORITHM/NLLEASTSQ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:56:44 $

% function handles to run and setup functions
F.RunFcn   = @RunGA;

defopts= setgaopt('gamincon');
chInputs= {'off|none|iter|final'  %         Display: [ 'off' | {'none'} | 'iter' | 'final' ]
{'numeric',[eps Inf]}  %            TolX: [ positive scalar {1e-6} ]
{'numeric',[eps Inf]}  %          TolFun: [ positive scalar {1e-6} ]
{'numeric',[eps Inf]}  %          TolCon: [ positive scalar {1e-6} ]
'off|on'               %         GradObj: [ 'on' | {'off'} ]
'off|on'               %      GradConstr: [ 'on' | {'off'} ]
{'numeric',[eps Inf]}  %   DiffMinChange: [ positive scalar {1e-8} ]
{'numeric',[eps Inf]}  %   DiffMaxChange: [ positive scalar {1e-1} ]
{'int',[1 Inf]}        %     MaxFunEvals: [ positive scalar (integer) ]
{'int',[1 Inf]}        %         MaxIter: [ positive scalar (integer) {10}]
{'int',[1 Inf]}        %       MaxGAIter: [ positive scalar (integer) {200} ]
{'int',[1 Inf]}        %     MaxNoChange: [ positive scalar (integer) {30} ]
{'numeric',[eps 1]}    %   MaxSimilarity: [ positive scalar less than 1 {0.95} ]
{'int',[1 Inf]}        %         PopSize: [ positive scalar (integer) ]
@checkgenetic          %   Hybridization: [ structure with the fields 'name' and 'option' ]
@checkgenetic          %         Fitness: [ structure with the fields 'name' and 'option' ]
@checkgenetic          %       Selection: [ structure with the fields 'name' and 'option' ]
@checkgenetic          %       Crossover: [ structure with the fields 'name' and 'option' ]
@checkgenetic};        %        Mutation: [ structure with the fields 'name' and 'option' ]defopts= [fieldnames(defopts),struct2cell(defopts)];

defopts= [fieldnames(defopts) struct2cell(defopts)];
for i=1:size(defopts,1)
	% gamincon 
	F= AddOption(F,defopts{i,1},defopts{i,2},chInputs{i},'',1);
end
	
F= AddOption(F,'StratCostFcn',0,'boolean','',0);
F= AddOption(F,'DisplayFcn','','');
	
F.name= 'Genetic';


% function [UpdatedContextObj,costFcn,OK,Results] = optimRunFcnTmpl(omgr,ContextObj,InitVals,varargin)
function [m,FVAL,OK,X] = RunGA(m,F,x0,varargin)

% get model constraints

% do we want a constraints manager class attached to the xregoptmgr to do this
[LB,UB,A,c,NONLCON]= constraints(m,varargin{:});
if ~isstr(NONLCON);
	% was number of nonlinear constraints
	NONLCON='';
end

DISPFUN= get(F,'DisplayFcn');
% last 2 options aren't gamincon parameters
gaopts= structopts(F,1:length(F.foptions)-2);

if get(F,'StratcostFcn')
	% strategy implemented cost function
	[X,FVAL,EXITFLAG,OK] = gamincon(F.costFunc,x0,LB,UB,A,c,NONLCON,gaopts,DISPFUN,F,m,varargin{:});
else
	[X,FVAL,EXITFLAG,OK] = gamincon(F.costFunc,x0,LB,UB,A,c,NONLCON,gaopts,DISPFUN,m,varargin{:});
end


function OK= checkgenetic(Property,Value);

OK=1;
try
	opt= setgaopt(Property,Value);
catch
	OK=0;
end
