function F= xregoptmgr(strategyFcn,ContextObj,costFcn)
%XREGOPTMGR optimisation manager class
%
% F= contextImplementation(xregoptmgr,ContextObj,RunFcn,CostFcn,name,caller);
% 
% F= xregoptmgr(strategyFcn,ContextObj,costFcn)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:57:05 $

if nargin==1 & (isstruct(strategyFcn) | ~isfield(strategyFcn,'version') | strategyFcn.version==1)
	F= strategyFcn;
	if ~isfield(F,'IsMaster')
		F.IsMaster= 1;
	end
	if ~isfield(F,'version')
		F.version= 1;
	end
	if isstruct(F)
		F= class(F,'xregoptmgr');
	end
	return
end

% function handle to setup routine
F.algorithm= [];

% label
F.name     = '';

% context which the xregoptmgr works with
F.Context   ='';

F.costFunc = [];
% [F,g]  = costFunc(x0,ContextObj,varargin)
%   g is gradient or jacobian and is not compulsory

% field to store algorithm setup options
F.foptions = [];

% function handles to run and setup functions
F.RunFcn = [];
% API
% [ContextObj,Cost,OK,varargout]= RunFcn(xregoptmgr,ContextObj,x0,varargin);
%   contextImplementation
% [ContextObj,Cost,OK,varargout]= RunFcn(ContextObj,xregoptmgr,x0,varargin);

F.Alternatives= {};
% array of function handles to alternative algorithms
%  [om,OK]= func(ContextObj,varargin)
%      should run without varargin?
%   the gui should check alternatives and provide a means of selecting algorithms

% context constraint generator
F.ConstraintFunc    = '';
% [LB,UB,A,c,nlfunc]  = constraintFunc(ContextObj,varargin)

% constraint store
F.Constraints = struct('LB',[],'UB',[],...  % bounds
	'A',[],'c',[],...                        % linear constraints
	'NLcon','');                             % nonlinear constraint function

F.IsMaster= 1;
F.version= 2;
F= class(F,'xregoptmgr');

if nargin>=2
	if isstr(strategyFcn)
		% convert to function handle
		strategyFcn= str2func(strategyFcn);
	end
	F.algorithm=strategyFcn; 
	if nargin==3
		if isstr(costFcn)
			% convert to function handle
			costFcn= str2func(costFcn);
		end
		F.costFunc= costFcn;
	end
	
	% set up strategy
	F= feval(strategyFcn,F,ContextObj);
	% store class definition in case this is required
	F.Context= class(ContextObj);
end
