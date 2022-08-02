function [Xmat,Fmat,EXITFLAG,OUTPUT] = NBI(FUN,X,NumberOfObjectives, NumberOfPoints,A,B,Aeq, Beq, LB, UB, NONLCON,options,varargin)
%CGNBI NBI optimizer
%
%  NBI Finds Pareto optimal points for several functions of several
%  variables. It is an implementation of 'Normal-Boundary Intersection: A
%  New Method for Generating the Pareto Surface in Nonlinear Multicriteria
%  Optimization Problems'  Indraneel Das and J.E. Dennis, 1996. 
%
%  NBI solves problems of the form:
%       min f1(X), f2(X), ..., fn(X)
%        X
%  subject to:  A*X  <= B, Aeq*X  = Beq (linear constraints)
%              C(X) <= 0, Ceq(X) = 0 (nonlinear constraints)
%              LB <= X <= UB         
%  X must be a column vector of size NumberOfVariables by 1 
%  FUN is a function that returns a column vector of size
%  NumberOfObjectives by 1 
%  The arguments of FUN must be [X, funcindex, varargin{:}], where
%  funcindex is the index of the function to evaluate and varargin are the
%  additional arguments passed to NBI. 
%  Xmat is of size NumberOfVariables by NumberOfSolutions
%  Fmat is of size NumberOfObjectives by NumberOfSolutions
%  NumberOfPoints should be the number of points taken in each component of
%  the NBI weight vector. For an equal stepsize (1/(NumberOfPoints-1)) in
%  each component, NumberOfPoints should be a positive integer.  To vary
%  the stepsize in each component a vector of positive integers of length
%  NumberOfObjectives-1 can be used.
%
%  [Xmat,Fmat,EXITFLAG]=CGNBI(FUN,X0,...) returns a string EXITFLAG that 
%  describes the exit condition of NBI.  
%  If EXITFLAG is:
%     > 0 then all shadow and NBI subproblems converged to a solution.
%     0   then the maximum number of function evaluations was reached in
%     one of the shadow or NBI subproblems
%     < 0 then one of the shadow or NBI subproblems NBI did not converge to
%     a solution.
%   
%  [Xmat,Fmat,EXITFLAG,OUTPUT]=NBI(FUN,X0,...) returns a structure OUTPUT
%  with the total number of shadow problem iterations taken in
%  OUTPUT.shadowIterations, the number of function evaluations in shadow
%  problem in OUTPUT.shadowFuncCount, the number of NBI subproblems solved
%  in OUTPUT.numberNBISubproblems, the total number of iterations taken in
%  the NBI subproblems in OUTPUT.NBISubproblemIterations, the number of
%  function evaluations in the NBI subproblems in
%  OUTPUT.NBISubproblemFuncCount

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.2 $    $Date: 2004/02/09 06:56:25 $



%%%%%start of input checks/preprocessing
defaultopt = struct('ShadowOptions', optimset(optimset('fmincon'), 'LargeScale', 'off'),...
                      'NBISubproblemOptions', optimset(optimset('fmincon'), 'LargeScale', 'off'));   

% If just 'defaults' passed in, return the default options in X
if nargin==1 & nargout <= 1 & isequal(FUN,'defaults')
   Xmat = defaultopt;
   return
end


if nargin < 6, error('NBI requires at least six input arguments'); end
if nargin < 12, options=defaultopt;
   if nargin < 11, NONLCON=[];
      if nargin < 10, UB = [];
         if nargin < 9, LB = [];
            if nargin < 8, Beq=[];
               if nargin < 7, Aeq =[];
               end, end, end, end, end, end

if NumberOfObjectives <2
    error('The number of objectives must be greater than 1.')
end
caller='constr';
lenVarIn = length(varargin);
XOUT=X(:);
numberOfVariables=length(XOUT);


switch optimget(options.ShadowOptions,'Display',defaultopt,'fast')
case {'off','none'}
   verbosity = 0;
case 'iter'
   verbosity = 2;
case 'final'
   verbosity = 1;
otherwise
   verbosity = 1;
end

if any(NumberOfPoints<2)
    error('The NumberOfPoints should be greater than 1 in each direction');
end
    
if ~isequal(length(NumberOfPoints), NumberOfObjectives -1) & ~isequal(length(NumberOfPoints), 1)
    error('The length of NumberOfPoints should be 1 (for the same resolution in each component) or the number of objectives -1');
end
if length(NumberOfPoints)==1
    % expand the NumberOfPoints vector
    NumberOfPoints = NumberOfPoints*ones(1, NumberOfObjectives-1);
end 



% Set to column vectors
B = B(:);
Beq = Beq(:);

[XOUT,l,u,msg] = checkbounds(XOUT,LB,UB,numberOfVariables);
if ~isempty(msg)
   EXITFLAG = -1;
   [FVAL,OUTPUT,LAMBDA,GRAD,HESSIAN] = deal([]);
   X(:)=XOUT;
   if verbosity > 0
      disp(msg)
   end
   return
end
lFinite = l(~isinf(l));
uFinite = u(~isinf(u));

% Is the gradient or Hessian used in the Shadow or NBI SubProblem?
if strcmp(options.ShadowOptions.GradObj, 'on' ) & strcmp(options.NBISubproblemOptions.GradObj, 'on' )
    % Only use gradients, if specified for both shadow and sub problems
    gradflag = true;
else
    gradflag = false;
end

% Is the gradient or Hessian used in the Shadow or NBI SubProblem for constraints?
if strcmp(options.ShadowOptions.GradConstr, 'on' ) & strcmp(options.NBISubproblemOptions.GradConstr, 'on' )
    % Only use gradients, if specified for both shadow and sub problems
    gradconstflag = true;
else
    gradconstflag = false;
end

hessflag = (strcmp(optimget(options.ShadowOptions,'Hessian',defaultopt,'fast'),'on') | strcmp(optimget(options.NBISubproblemOptions,'Hessian',defaultopt,'fast'),'on'));
if isempty(NONLCON)
   constflag = 0;
else
   constflag = 1;
end

% Convert to inline function as needed
if ~isempty(FUN)  % will detect empty string, empty matrix, empty cell array
   [funfcn, msg] = optimfcnchk(FUN,'NBI',length(varargin),gradflag,hessflag);
else
   errmsg = sprintf('%s\n%s', ...
      'FUN must be a function or an inline object;', ...
      ' or, FUN may be a cell array that contains these type of objects.');
   error(errmsg)
end

if constflag % NONLCON is non-empty
   [confcn, msg] = optimfcnchk(NONLCON,'NBI',length(varargin),gradconstflag,[],1);
else
   confcn{1} = '';
end

[rowAeq,colAeq]=size(Aeq);
% if only l and u then call sfminbx
lenvlb=length(l);
lenvub=length(u);


CHG = 1e-7*abs(XOUT)+1e-7*ones(numberOfVariables,1);
i=1:lenvlb;
lindex = XOUT(i)<l(i);
if any(lindex),
    XOUT(lindex)=l(lindex)+1e-4; 
end
i=1:lenvub;
uindex = XOUT(i)>u(i);
if any(uindex)
    XOUT(uindex)=u(uindex);
    CHG(uindex)=-CHG(uindex);
end
X(:) = XOUT;

% Evaluate function
GRAD=[];
HESS = [];

switch funfcn{1}
case 'fun'
   try
      f = feval(funfcn{3},X,[1:NumberOfObjectives],varargin{:});
   catch
      errmsg = sprintf('%s\n%s\n\n%s',...
         'NBI cannot continue because user supplied objective function', ...
         ' failed with the following error:', lasterr);
      error(errmsg);
   end
case 'fungrad'
   try
      [f,GRAD] = feval(funfcn{3},X,[1:NumberOfObjectives], varargin{:});
   catch
      errmsg = sprintf('%s\n%s\n\n%s',...
         'NBI cannot continue because user supplied objective function', ...
         ' failed with the following error:', lasterr);
      error(errmsg);
   end
case 'fungradhess'
   try
      [f,GRAD,HESS] = feval(funfcn{3},X,[1:NumberOfObjectives],varargin{:});
   catch
      errmsg = sprintf('%s\n%s\n\n%s',...
         'NBI cannot continue because user supplied objective function', ...
         ' failed with the following error:', lasterr);
      error(errmsg);
   end
case 'fun_then_grad'
   try
      f = feval(funfcn{3},X,[1:NumberOfObjectives],varargin{:});
   catch
      errmsg = sprintf('%s\n%s\n\n%s',...
         'NBI cannot continue because user supplied objective function', ...
         ' failed with the following error:', lasterr);
      error(errmsg);
   end
   try
      GRAD = feval(funfcn{4},X,[1:NumberOfObjectives],varargin{:});
   catch
      errmsg = sprintf('%s\n%s\n\n%s',...
         'NBI cannot continue because user supplied objective gradient function', ...
         ' failed with the following error:', lasterr);
      error(errmsg);
   end
case 'fun_then_grad_then_hess'
   try
      f = feval(funfcn{3},X,[1:NumberOfObjectives],varargin{:});
   catch
      errmsg = sprintf('%s\n%s\n\n%s',...
         'NBI cannot continue because user supplied objective function', ...
         ' failed with the following error:', lasterr);
      error(errmsg);
   end
   try
      GRAD = feval(funfcn{4},X,[1:NumberOfObjectives],varargin{:});
   catch
      errmsg = sprintf('%s\n%s\n\n%s',...
         'NBI cannot continue because user supplied objective gradient function', ...
         ' failed with the following error:', lasterr);
      error(errmsg);
   end
   try
      HESS = feval(funfcn{5},X,[1:NumberOfObjectives],varargin{:});
   catch 
      errmsg = sprintf('%s\n%s\n\n%s',...
         'NBI cannot continue because user supplied objective Hessian function', ...
         ' failed with the following error:', lasterr);
      error(errmsg);
   end
otherwise
   error('Undefined calltype in NBI');
end

% Evaluate constraints
switch confcn{1}
case 'fun'
   try 
      [ctmp,ceqtmp] = feval(confcn{3},X,[],varargin{:});
      c = ctmp(:); ceq = ceqtmp(:);
      cGRAD = zeros(numberOfVariables,length(c));
      ceqGRAD = zeros(numberOfVariables,length(ceq));
   catch
      if findstr(xlate('Too many output arguments'),lasterr)
          if isa(confcn{3},'inline')
              errmsg = sprintf('%s%s%s\n%s\n%s\n%s', ...
                  'The inline function ',formula(confcn{3}),' representing the constraints',...
                  ' must return two outputs: the nonlinear inequality constraints and', ...
                  ' the nonlinear equality constraints.  At this time, inline objects may',...
                  ' only return one output argument: use an M-file function instead.');
          elseif isa(confcn{3},'function_handle')
              errmsg = sprintf('%s%s%s\n%s%s', ...
                  'The constraint function ',func2str(confcn{3}),' must return two outputs:',...
                  ' the nonlinear inequality constraints and', ...
                  ' the nonlinear equality constraints.');
          else
              errmsg = sprintf('%s%s%s\n%s%s', ...
                  'The constraint function ',confcn{3},' must return two outputs:',...
                  ' the nonlinear inequality constraints and', ...
                  ' the nonlinear equality constraints.');
          end
         error(errmsg)
      else
         errmsg = sprintf('%s\n%s\n\n%s',...
            'NBI cannot continue because user supplied nonlinear constraint function', ...
            ' failed with the following error:', lasterr);
         error(errmsg);
      end
   end
   
case 'fungrad'
   try
      [ctmp,ceqtmp,cGRAD,ceqGRAD] = feval(confcn{3},X,[],varargin{:});
      c = ctmp(:); ceq = ceqtmp(:);
   catch
      errmsg = sprintf('%s\n%s\n\n%s',...
         'NBI cannot continue because user supplied nonlinear constraint function', ...
         ' failed with the following error:', lasterr);
      error(errmsg);
   end
case 'fun_then_grad'
   try
      [ctmp,ceqtmp] = feval(confcn{3},X,[],varargin{:});
      c = ctmp(:); ceq = ceqtmp(:);
      [cGRAD,ceqGRAD] = feval(confcn{4},X,[],varargin{:});
   catch
      errmsg = sprintf('%s\n%s%s\n\n%s',...
         'NBI cannot continue because user supplied nonlinear constraint function', ...
         'or nonlinear constraint gradient function',...
         ' failed with the following error:', lasterr);
      error(errmsg);
   end
case ''
   c=[]; ceq =[];
   cGRAD = zeros(numberOfVariables,length(c));
   ceqGRAD = zeros(numberOfVariables,length(ceq));
otherwise
   error('Undefined calltype in NBI');
end

non_eq = length(ceq);
non_ineq = length(c);
[lin_eq,Aeqcol] = size(Aeq);
[lin_ineq,Acol] = size(A);
[cgrow, cgcol]= size(cGRAD);
[ceqgrow, ceqgcol]= size(ceqGRAD);

eq = non_eq + lin_eq;
ineq = non_ineq + lin_ineq;

if ~isempty(Aeq) & Aeqcol ~= numberOfVariables
   error('Aeq has the wrong number of columns.')
end
if ~isempty(A) & Acol ~= numberOfVariables
   error('A has the wrong number of columns.')
end
if  cgrow~=numberOfVariables & cgcol~=non_ineq
   error('Gradient of the nonlinear inequality constraints is the wrong size.')
end
if ceqgrow~=numberOfVariables & ceqgcol~=non_eq
   error('Gradient of the nonlinear equality constraints is the wrong size.')
end

%%%%%end of input checks/preprocessing

% Determine the shadow minima SHADOWFVAL that occurs at SHADOWX
[SHADOWX, SHADOWFVAL, EXITFLAG, OUTPUT] = cgnbishadow(funfcn{3}, X, NumberOfObjectives, A,B,Aeq,Beq,LB,UB,NONLCON, options.ShadowOptions, varargin{:}); 

% compute the payoff matrix and the quasi-normal
[payoffmx, normal] =i_payoffmatrix(SHADOWX, SHADOWFVAL,funfcn{3}, varargin{:});

% generate the weights Beta
Beta = i_generateBeta(NumberOfPoints); 

numberOfWeights = size(Beta,1);
Fmat = Inf*ones(NumberOfObjectives, numberOfWeights);
Xmat = zeros(numberOfVariables, numberOfWeights);
t = zeros(numberOfWeights,1 );

OUTPUT.numberNBISubproblems = numberOfWeights;

% for each weighting of Beta, solve the NBI subproblem
OUTPUT.NBISubproblemIterations = 0;
OUTPUT.NBISubproblemFuncCount = 0;

if payoffmx==0
    % nothing to tradeoff
    if verbosity
        fprintf('The shadow minima do not differ from one another. This suggests that all objectives can be minimized simultaneously. Check that the objectives are competing or increase tolerances.');
    end
    for j = 1:numberOfWeights
        Xmat(:,j) = SHADOWX(:,1);
        Fmat(:,j) = SHADOWFVAL(:);
    end
    return
end

% Set up Fmat and Xmat with the shadowminima information
[shadowindices, objectiveindices] = find(Beta==1);
for i = 1:length(shadowindices)
    Fmat(:, shadowindices(i)) = payoffmx(:,objectiveindices(i)) + SHADOWFVAL;
    Xmat(:, shadowindices(i)) = SHADOWX(:,objectiveindices(i));
end

for i =1:numberOfWeights
    
    % index can only ever be empty or single valued
    index = find(Beta(i,:) ==1);
    if index 
        % this is a shadow minimum problem -- use the previous result
        XtBeta = [SHADOWX(:,index); 0];
        OUTPUTi.iterations = 0;
        OUTPUTi.funcCount = 0;
        EXITFLAGi = 1;
    else
        % display solution number
        if strcmp(options.NBISubproblemOptions.Display, 'iter')
            fprintf('Solution %d : \n', i);
        end
        
        % solve the NBI_subproblem
        [XtBeta, EXITFLAGi, OUTPUTi] = cgnbisubproblem(funfcn{3}, Xt0, payoffmx, Beta(i,:), normal, SHADOWFVAL, A,B,Aeq,Beq,LB,UB,NONLCON, options.NBISubproblemOptions, varargin{:}); 
   
        % compute the value of the objective functions at this solution
        Fmat(:,i) = feval(funfcn{3}, XtBeta(1:end-1,1), [1:NumberOfObjectives], varargin{:});
    end
    
    % save the X found for this solution
    Xmat(:,i) = XtBeta(1:end-1);
    
    % set the start position for the next solution
    Xt0 = XtBeta; 
    
    % update exitflag and output 
    if EXITFLAGi <  0
        EXITFLAG = -1;
    elseif EXITFLAGi == 0 & EXITFLAG >=0
        EXITFLAG = 0;
    end
    OUTPUT.NBISubproblemIterations =  OUTPUT.NBISubproblemIterations + OUTPUTi.iterations;
    OUTPUT.NBISubproblemFuncCount = OUTPUT.NBISubproblemFuncCount+ OUTPUTi.funcCount;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [payoffmx, normal] =i_payoffmatrix(SHADOWX, SHADOWFVAL,FUN, varargin)

% generate the payoff matric and the normal

nObjectives = length(SHADOWFVAL);
payoffmx = zeros(nObjectives, nObjectives);

for i =1:nObjectives
    payoffmx(:,i) = feval(FUN, SHADOWX(:,i), [1:nObjectives], varargin{:}) - SHADOWFVAL;
end

normal = - payoffmx*ones(nObjectives, 1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Beta =i_generateBeta(NumberOfPoints)

n = length(NumberOfPoints)+1;

prevBeta = [0:(NumberOfPoints(1)-1)]'/(NumberOfPoints(1)-1);
Beta = prevBeta;

for i = 2:n-1   
    ki = round((1-sum(prevBeta,2))*(NumberOfPoints(i)-1));
    Beta = [];
    for j =1:size(prevBeta,1)
        BetaVec = [0:ki(j)]'/(NumberOfPoints(i)-1);
        nreplications = length(BetaVec); 
        Beta = [Beta; [repmat(prevBeta(j,:), nreplications,1) BetaVec] ]; 
    end
    prevBeta = Beta;
end
BetaVec = 1 - sum(prevBeta,2);

Beta = [Beta BetaVec];


