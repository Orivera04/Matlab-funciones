function [X,FVAL,EXITFLAG,OUTPUT] = gamincon(FUN,X,LB,UB,A,B,NONLCON,options,DISPFUN,varargin)
%GAMINCON Finds the constrained minimum of a function of several variables.
%   GAMINCON solves problems of the form:
%       min f(x)
%        x
%   subject to:
%       A*x <= b
%       C(x) <= 0
%       LB <= x <= UB
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


   
%
%   $Revision: 1.4.2.3 $  $Date: 2004/04/04 03:30:40 $
%
defaultopt = struct('Display','none',...
	'TolX',1.0e-6,...
	'TolFun',1.0e-6,...
	'TolCon',1.0e-6,...
	'GradObj','off',...
	'GradConstr','off',...
	'DiffMinChange',1.0e-8,...
	'DiffMaxChange',1.0e-1,...
	'MaxFunEvals','100*numberofvariables',...
	'MaxIter',10,...
	'MaxGAIter',200,...
	'MaxNoChange',30,...
	'MaxSimilarity',0.95,...
	'PopSize',20,...
	'Hybridization',struct('name','sorted','option',[10,10]),...
	'Fitness',struct('name','scaling','option',[]),...
	'Selection',struct('name','normGeometric','option',0.08),...
	'Crossover',struct('name',{'simple','arithmetic','heuristic'},...
	'option',{1,1,[1 3]}),...
	'Mutation',struct('name',{'boundary','multiNonUniform','nonUniform','uniform'},...
	'option',{2,[3,3],[2,3],2}));
if ((nargin == 1) & (nargout <= 1) & isequal(FUN,'defaults'))
	X = defaultopt;
	return
end
if (nargin < 4)
	error('GAMINCON requires at least four input arguments.');
end
if (nargin < 9)
	DISPFUN = [];
	if (nargin < 8)
		options = [];
		if (nargin < 7)
			NONLCON = [];
			if (nargin < 6)
				B = [];
				if (nargin < 5)
					A = [];
				end
			end
		end
	end
end
[msg,x,lb,ub] = checkbounds(X,LB,UB);
if (~isempty(msg))
	error(msg);
end
popSize = getgaopt(options,'PopSize',defaultopt,'fast');
numVars = length(x);
range = ub-lb;
X0 = [x range(:,ones(1,popSize-1)).*rand(numVars,popSize-1)+lb(:,ones(1,popSize-1))];
switch (getgaopt(options,'Display',defaultopt,'fast'))
case {'off','none'}
	verbosity = 0;
case 'iter'
	verbosity = 2;
case 'final'
	verbosity = 1;
otherwise
	verbosity = 0;
end
gradflag =  strcmp(getgaopt(options,'GradObj',defaultopt,'fast'),'on');
gradconstflag =  strcmp(getgaopt(options,'GradConstr',defaultopt,'fast'),'on');
hessflag = false;
line_search = true;
if (isempty(NONLCON))
	constflag = false;
else
	constflag = true;
end
if (isempty(DISPFUN))
	displflag = false;
else
	displflag = true;
end
if (~isempty(FUN))
	[funfcn,msg] = optimfcnchk(FUN,'gamincon',length(varargin),gradflag);
else
	error('FUN must be a function or an inline object.');
end
if (constflag)
	[confcn,msg] = optimfcnchk(NONLCON,'gamincon',length(varargin),gradconstflag,1);
else
	confcn{1} = '';
end
if (displflag)
	[disfcn,msg] = optimfcnchk(DISPFUN,'gamincon',length(varargin)+2);
else
	disfcn{1} = '';
end
B = B(:);
%----- Integer variables not excluded TO DO
x(:) = X0(:,1);
% Evaluate function
GRAD = zeros(numVars,1);
HESS = [];
switch (funfcn{1})
case 'fun'
	try
		f = feval(funfcn{3},x,varargin{:});
	catch
		error(sprintf('%s\n%s\n%s',...
			'GAMINCON cannot continue. User supplied objective function',...
			'failed with the following error:',lasterr));
	end
case 'fungrad'
	try
		[f,GRAD(:)] = feval(funfcn{3},x,varargin{:});
	catch
		error(sprintf('%s\n%s\n%s',...
			'GAMINCON cannot continue. User supplied objective/gradient function',...
			'failed with the following error:',lasterr));
	end
case 'fun_then_grad'
	try
		f = feval(funfcn{3},x,varargin{:});
	catch
		error(sprintf('%s\n%s\n%s',...
			'GAMINCON cannot continue. User supplied objective function',...
			'failed with the following error:',lasterr));
	end
	try
		GRAD(:) = feval(funfcn{4},x,varargin{:});
	catch
		error(sprintf('%s\n%s\n%s',...
			'GAMINCON cannot continue. User supplied objective gradient function',...
			'failed with the following error:',lasterr));
	end
otherwise
	error('Undefined calltype in GAMINCON.');
end
% Evaluate constraints
switch (confcn{1})
case 'fun'
	try 
		ctmp = feval(confcn{3},x,varargin{:});
		c = ctmp(:);
		cGRAD = zeros(numVars,length(c));
	catch
		error(sprintf('%s\n%s\n%s',...
			'GAMINCON cannot continue. User supplied nonlinear constraint function',...
			'failed with the following error:',lasterr));
	end
case 'fungrad'
	try
		[ctmp,cGRAD] = feval(confcn{3},x,varargin{:});
		c = ctmp(:);
	catch
		error(sprintf('%s\n%s\n%s',...
			'GAMINCON cannot continue. User supplied nonlinear constraint/gradient function', ...
			'failed with the following error:',lasterr));
	end
case 'fun_then_grad'
	try
		ctmp = feval(confcn{3},x,varargin{:});
		c = ctmp(:);
	catch
		error(sprintf('%s\n%s\n%s',...
			'GAMINCON cannot continue. User supplied nonlinear constraint function',...
			'failed with the following error:',lasterr));
	end
	try
		cGRAD = feval(confcn{4},x,varargin{:});
	catch
		error(sprintf('%s\n%s\n%s',...
			'GAMINCON cannot continue. User supplied nonlinear constraint gradient function',...
			'failed with the following error:',lasterr));
	end
case ''
	c = [];
	cGRAD = zeros(numVars,length(c));
otherwise
	error('Undefined calltype in GAMINCON');
end
nonIneq = length(c);
[linIneq,Acol] = size(A);
[cgrow,cgcol]= size(cGRAD);
ineq = nonIneq+linIneq;
if (~isempty(A) & (Acol ~= numVars))
	error('A has the wrong number of columns.')
end
if (~isempty(A) & (linIneq ~= length(B)))
	error('B has the wrong number of rows.');
end
if ((cgrow ~= numVars) & (cgcol ~= nonIneq))
	error('Gradient of the nonlinear inequality constraints is the wrong size.')
end
global OPT_STOP OPT_STEP
OPT_STEP = 1;
OPT_STOP = 0; 
%-----------------
suphybrid = {'sorted','random'};
supfitness = {'scaling','ranking'};
supselect = {'normGeometric','tournament','roulette'};
supxover = {'simple','arithmetic','heuristic'};
supmutat = {'boundary','multiNonUniform','nonUniform','uniform'};
%--------- hybridization, fitness and select must be scalars
opt = getgaopt(options,'Hybridization',defaultopt,'fast');
[hybrid,opthybrid] = opermatch(opt,suphybrid);
opt = getgaopt(options,'Fitness',defaultopt,'fast');
[fitness,optfitness] = opermatch(opt,supfitness);
opt = getgaopt(options,'Selection',defaultopt,'fast');
[select,optselect] = opermatch(opt,supselect);
opt = getgaopt(options,'Crossover',defaultopt,'fast');
[xover,optxover] = opermatch(opt,supxover);
opt = getgaopt(options,'Mutation',defaultopt,'fast');
[mutat,optmutat] = opermatch(opt,supmutat);
nxover = length(xover);
nmutat = length(mutat);
L0 = zeros(1,popSize);
for (k = 1:popSize)
	x(:) = X0(:,k);
	L0(k) = feval(funfcn{3},x,varargin{:});
end
iter = 0;
switch (disfcn{1})
case 'fun'
	try
		feval(disfcn{3},iter,X0,L0,varargin{:});
	catch
		error(sprintf('%s\n%s\n%s',...
			'GAMINCON cannot continue. User supplied display function',...
			'failed with the following error:',lasterr));
	end
case ''
otherwise
	error('Undefined calltype in GAMINCON.');
end
F0 = zeros(size(L0));
L1 = zeros(size(L0));
X1 = zeros(size(X0));
c1 = zeros(numVars,1);
c2 = zeros(numVars,1);
p1 = zeros(numVars,1);
p2 = zeros(numVars,1);
bestx = zeros(numVars,1);
done = false;
tolfun = getgaopt(options,'TolFun',defaultopt,'fast');
maxgen = getgaopt(options,'MaxGAIter',defaultopt,'fast');
maxnoc = getgaopt(options,'MaxNoChange',defaultopt,'fast');
maxsim = getgaopt(options,'MaxSimilarity',defaultopt,'fast');
bufnoc = rand(maxnoc,1);
topnoc = 1;
iter = 1;
hciter = opthybrid{1}(1);
hcsize = opthybrid{1}(2);
hindex = zeros(1,hcsize);
switch (hybrid)
case 1
	hcpind = zeros(1,popSize);
case 2
otherwise
end
switch (fitness)
case 1
case 2
	rankfun = zeros(1,popSize);
	rankfun(:) = 2*[0:popSize-1]/(popSize-1);
	rankind = zeros(1,popSize);
otherwise
end
switch (select)
case 1
	q = optselect{1};
	r = q/(1-(1-q)^popSize);
	indices = zeros(1,popSize);
	indices(:) = popSize-1:-1:0;
	gprob = r*(1-q).^indices;
	fit = zeros(1,popSize);
	urn = zeros(1,popSize);
case 2
	trnSize = optselect{1};
	tourind = zeros(popSize,trnSize);
	indices = zeros(1,popSize);
case 3
	rprob = zeros(1,popSize);
	urn = zeros(1,popSize);
otherwise
end
for (k = 1:nmutat)
	job = mutat(k);
	mopt = optmutat{k};
	switch (job)
	case 1
	case 2
		mmshape = mopt(2);
		MD = zeros(numVars,1);
		CPOINT = false(numVars,1);
	case 3
		smshape = mopt(2);
	case 4
	otherwise
	end
end
for (k = 1:nxover)
	job = xover(k);
	xopt = optxover{k};
	switch (job)
	case 1
	case 2
	case 3
		retry = xopt(2);
		t1 = zeros(numVars,1);
		t2 = zeros(numVars,1);
	otherwise
	end
end
%
while (~done)
	%----- TODO do not call at each iter, do not apply to all members
	if (rem(iter,hciter) == 0)
		OPT_STEP = 1;
		switch (hybrid)
		case 1
			[dummy,hcpind(:)] = sort(L0);
			hindex(:) = hcpind(1:hcsize);
		case 2
			hindex(:) = floor(rand(1,hcsize)*popSize)+1;
		otherwise
		end
		for (k = hindex)
			x(:) = X0(:,k);
			CHG = 1e-7*abs(x)+1e-7*ones(numVars,1);
			%
			switch (funfcn{1})
			case 'fun'
				f = L0(k);
			case 'fungrad'
				[f,GRAD(:)] = feval(funfcn{3},x,varargin{:});
			case 'fun_then_grad'
				f = L0(k);
				GRAD(:) = feval(funfcn{4},x,varargin{:});
			otherwise
			end
			switch (confcn{1})
			case 'fun'
				ctmp = feval(confcn{3},x,varargin{:});
				c = ctmp(:);
				cGRAD = zeros(numVars,length(c));
			case 'fungrad'
				[ctmp,cGRAD] = feval(confcn{3},x,varargin{:});
				c = ctmp(:);
			case 'fun_then_grad'
				ctmp = feval(confcn{3},x,varargin{:});
				c = ctmp(:);
				cGRAD = feval(confcn{4},x,varargin{:});
			case ''
				c = [];
				cGRAD = zeros(numVars,length(c));
			otherwise
				error('Undefined calltype in GAMINCON');
			end
			[x,f,lambda,exitflag] = nlconst(funfcn,x,lb,ub,A,B,[],[],confcn,options,defaultopt,0,...
				gradflag,gradconstflag,hessflag,CHG,f,GRAD,HESS,c,[],cGRAD,[],...
				varargin{:});
			X0(:,k) = x;
			L0(k) = f;
			if (OPT_STOP)
				break;
			end
		end
	end
	if (displflag)
		feval(disfcn{3},iter,X0,L0,varargin{:});
	end
	OPT_STEP = 0;
	if (OPT_STOP)
		break;
	end
	switch (fitness)
	case 1
		F0(:) = 1+max(L0)-L0;
	case 2
		[dummy,rankind(:)] = sort(-L0);
		L1(:) = L0(rankind);
		i1 = 1;
		for (i2 = [find(L1(1:popSize-1) ~= L1(2:popSize)),popSize])
			F0(i1:i2) = sum(rankfun(i1:i2))/(i2-i1+1);
			i1 = i2+1;
		end
		[dummy,rankind(:)] = sort(rankind);
		F0(:) = F0(rankind);
	otherwise
	end
	[dummy,ind] = max(F0);
	bestx(:) = X0(:,ind);
	bestl = L0(ind);
	%
	bufnoc(topnoc) = bestl;
	topnoc = topnoc+1;
	if (topnoc > maxnoc)
		topnoc = 1;
	end
	if ((iter > maxgen) | all(abs(bufnoc-bestl) <= tolfun) | (sum(abs(L0-bestl) <= tolfun) >= maxsim*popSize))
		done = true;
	else
		switch (select)
		case 1
			[dummy,indices(:)] = sort(F0);
			fit(indices) = gprob;
			fit(:) = cumsum(fit);
			urn(:) = sort(rand(1,popSize));
			i1 = 1;
			i2 = 1;
			while (i2 <= popSize)
				if (urn(i2) < fit(i1))
					X1(:,i2) = X0(:,i1);
					L1(i2) = L0(i1);
					i2 = i2+1;
				else
					i1 = i1+1;
				end
			end
		case 2
			tourind(:) = floor(rand(popSize,trnSize)*popSize)+1;
			[dummy,indices(:)] = max(reshape(F0(tourind),trnSize,popSize));
			indices(:) = diag(tourind(:,indices));
			X1(:) = X0(:,indices);
			L1(:) = L0(indices);
		case 3
			rprob(:) = cumsum(F0/sum(F0));
			urn(:) = sort(rand(1,popSize));
			i1 = 1;
			i2 = 1;
			while (i2 <= popSize)
				if (urn(i2) < rprob(i1))
					X1(:,i2) = X0(:,i1);
					L1(i2) = L0(i1);
					i2 = i2+1;
				else
					i1 = i1+1;
				end
			end
		otherwise
		end
		for (k = 1:nxover)
			job = xover(k);
			xopt = optxover{k};
			nx = xopt(1);
			for (l = 1:nx)
				i1 = round(rand*(popSize-1)+1);
				i2 = round(rand*(popSize-1)+1);
				p1(:) = X1(:,i1);
				p2(:) = X1(:,i2);
				switch (job)
				case 1
					cpoint = round(rand*(numVars-2)+1);
					c1(:) = [p1(1:cpoint);p2(cpoint+1:end)];
					c2(:) = [p2(1:cpoint);p1(cpoint+1:end)];
				case 2
					alfa = rand;
					beta = 1-alfa;
					c1(:) = alfa*p1+beta*p2;
					c2(:) = beta*p1+alfa*p2;
				case 3
					feasible = false;
					l1 = 0;
					if (F0(i1) > F0(i2))
						t2(:) = p1; 
						t1(:) = p2;
					else
						t2(:) = p2;
						t1(:) = p1;
					end
					while (l1 < retry)
						alfa = rand;
						beta = 1+alfa;
						c1(:) = beta*t2-alfa*t1;
						if (all(c1 <= ub) & all(c1 >= lb))
							l1 = retry;
							feasible = true;
						else
							l1 = l1+1;
						end
					end
					if(~feasible) 
						c1(:) = t1;
					end
					c2(:) = t2;
				otherwise
				end
				if (all(c1 == p1))
					l1 = L1(i1);
				elseif (all(c1 == p2))
					l1 = L1(i2);
				else
					l1 = feval(funfcn{3},c1,varargin{:});
				end
				if (all(c2 == p1))
					l2 = L1(i1);
				elseif (all(c2 == p2))
					l2 = L1(i2);
				else
					l2 = feval(funfcn{3},c2,varargin{:});
				end
				X1(:,[i1,i2]) = [c1,c2];
				L1([i1,i2]) = [l1;l2];
				if (OPT_STOP)
					break;
				end
			end
			if (OPT_STOP)
				break;
			end
		end
		if (~OPT_STOP)
			for (k = 1:nmutat)
				job = mutat(k);
				mopt = optmutat{k};
				nm = mopt(1);
				for (l = 1:nm)
					i1 = round(rand*(popSize-1)+1);
					p1(:) = X1(:,i1);
					c1(:) = p1;
					switch (job)
					case 1
						cpoint = round(rand*(numVars-1)+1);
						if (rand >= 0.5)
							c1(cpoint) = ub(cpoint);
						else
							c1(cpoint) = lb(cpoint);
						end
					case 2
						ratio = iter/maxgen;
						alfa = (rand*(1-ratio)).^smshape;
						beta = 1-alfa;
						MD = rand(numVars,1);
						CPOINT(:) = MD >= 0.5;
						c1(CPOINT) = beta*p1(CPOINT)+alfa*ub(CPOINT);
						CPOINT(:) = ~CPOINT;
						c1(CPOINT) = beta*p1(CPOINT)+alfa*lb(CPOINT);
					case 3
						cpoint = round(rand*(numVars-1)+1);
						ratio = iter/maxgen;
						alfa = (rand*(1-ratio)).^smshape;
						beta = 1-alfa;
						if (rand >= 0.5)
							c1(cpoint) = beta*p1(cpoint)+alfa*ub(cpoint);
						else
							c1(cpoint) = beta*p1(cpoint)+alfa*lb(cpoint);
						end
					case 4
						cpoint = round(rand*(numVars-1)+1);
						c1(cpoint) = lb(cpoint)+rand*range(cpoint);
					otherwise
					end
					if (all(c1 == p1))
						l1 = L1(i1);
					elseif (all(c1 == p2))
						l1 = L1(i2);
					else
						l1 = feval(funfcn{3},c1,varargin{:});
					end
					X1(:,i1) = c1;
					L1(i1) = l1;
					if (OPT_STOP)
						break;
					end
				end
				if (OPT_STOP)
					break;
				end
			end
		end
		X0(:) = X1;
		L0(:) = L1;
		[dummy,ind] = max(L0);
		X0(:,ind) = bestx;
		L0(ind) = bestl;
		iter = iter+1;
		if (OPT_STOP)
			break;
		end
	end
end
if (~OPT_STOP)
	OPT_STEP = 1;
	x(:) = bestx;
	CHG = 1e-7*abs(x)+1e-7*ones(numVars,1);
	%
	switch (funfcn{1})
	case 'fun'
		f = bestl;
	case 'fungrad'
		[f,GRAD(:)] = feval(funfcn{3},x,varargin{:});
	case 'fun_then_grad'
		f = bestl;
		GRAD(:) = feval(funfcn{4},x,varargin{:});
	otherwise
	end
	switch (confcn{1})
	case 'fun'
		ctmp = feval(confcn{3},x,varargin{:});
		c = ctmp(:);
		cGRAD = zeros(numVars,length(c));
	case 'fungrad'
		[ctmp,cGRAD] = feval(confcn{3},x,varargin{:});
		c = ctmp(:);
	case 'fun_then_grad'
		ctmp = feval(confcn{3},x,varargin{:});
		c = ctmp(:);
		cGRAD = feval(confcn{4},x,varargin{:});
	case ''
		c = [];
		cGRAD = zeros(numVars,length(c));
	otherwise
		error('Undefined calltype in GAMINCON');
	end
	if (isempty(options))
		defaultopt.MaxIter = 30*numVars;
	else
		options.MaxIter = max(options.MaxIter,30*numVars);
	end
	[x,f,lambda,exitflag] = nlconst(funfcn,x,lb,ub,A,B,[],[],confcn,options,defaultopt,0,...
		gradflag,gradconstflag,hessflag,CHG,f,GRAD,HESS,c,[],cGRAD,[],...
		varargin{:});
	bestx(:) = x;
	bestl = f;
end
X(:) = bestx;
FVAL = bestl;
EXITFLAG = 1;
OUTPUT = struct('iterations',iter,...
	'population',X0,...
	'fitness',L0);
return

function [msg,xout,lbout,ubout] = checkbounds(x,lbin,ubin)
%CHECKBOUNDS Move the initial points within the (valid) bounds.
%
%

msg = '';
xout = x(:);
lbout = lbin(:); 
ubout = ubin(:); 
lenlb = length(lbout);
lenub = length(ubout);
nvars = length(x);
if ((lenlb ~= nvars) | (lenub ~= nvars))
	msg = 'Length of lower/upper bounds not equal to the number of variables.';
elseif (any(~isfinite(lbout)) | any(~isfinite(ubout)))
	msg = 'Lower/upper bounds are not finite.';
elseif (any(lbout >= ubout))
	msg = 'Lower bounds exceed the corresponding upper bounds.';
else
	if (any(xout < lbout) | any(xout > ubout))
		msg = 'Initial solution is not feasible.';
	end
end
return

function opt = getgaopt(options,NAME,default,flag)
%GETGAOPT Get OPTIONS parameters.
%
%

if (nargin < 4)
	flag = '';
end
if (isequal(flag,'fast'))
	opt = getoptfast(options,NAME,default);
	return
end
if (~isempty(options) & ~isa(options,'struct'))
	error('First argument must be an options structure created with SETGAOPT.');
end
if (isempty(options))
	opt = default;
	return
end
FIELDS = {'Display',...
		'TolX',...
		'TolFun',...
		'TolCon',...
		'GradObj',...
		'GradConstr',...
		'DiffMinChange',...
		'DiffMaxChange',...
		'MaxFunEvals',...
		'MaxIter',...
		'HillClimbIter',...
		'MaxGAIter',...
		'MaxNoChange',...
		'MaxSimilarity',...
		'PopSize',...
		'Fitness',...
		'Selection',...
		'Crossover',...
		'Mutation',...
		'DiffMaxChange',...
		'DiffMinChange',...
		'MaxFunEvals'};
fields = lower(FIELDS);
name = lower(NAME);
ind = strmatch(name,fields);
if (isempty(ind))
	error(sprintf('Unrecognized property name ''%s''.',NAME));
elseif (length(ind) > 1)
	k = strmatch(name,fields,'exact');
	if (length(k) == 1)
		ind = k;
	else
		error(sprintf('Ambiguous property name ''%s''.',NAME));
	end
end
if (any(strcmp(FIELDS,FIELDS{ind,:})))
	opt = getfield(options, FIELDS{ind,:});
	if (isempty(opt))
		opt = default;
	end
else
	opt = default;
end
return

function value = getoptfast(options,name,defaultopt)
%GETOPTFAST Get OPTIONS parameter with no error checking so fast.
%

S.type = '.';
S.subs = name;
if (~isempty(options))
	value = subsref(options,S);
else
	value = [];
end
if (isempty(value))
	value = subsref(defaultopt,S);
end
return

function [oper,opts] = opermatch(options,FIELDS)
%OPERMATCH Get operators and the associated parameters.
%
%

if (~isempty(options) & ~isa(options,'struct'))
	error('First argument must be an options structure created with SETGAOPT.');
end
names = fieldnames(options);
if (isempty(strmatch('name',names)) | isempty(strmatch('option',names)))
	error('An option structure must be created with SETGAOPT.');
end
NAMES = {options.name};
names = lower(NAMES);
nop = length(names);
fields = lower(FIELDS);
oper = zeros(1,nop);
opts = cell(1,nop);
for (k = 1:nop)
	name = names{k};
	ind = strmatch(name,fields);
	if (isempty(ind))
		error(sprintf('Unrecognized property name ''%s''.',NAMES{k}));
	elseif (length(ind) > 1)
		ind = strmatch(name,fields,'exact');
		if (length(ind) ~= 1)
			error(sprintf('Ambiguous property name ''%s''.',NAMES{k}));
		end
	end
	oper(k) = ind;
	opts{k} = options(k).option;
end
return

function f = getfield(s,field)
%GETFIELD Get structure field contents.
% 

sref.type = '.';
sref.subs = field;
f = subsref(s,sref);
return

function [allfcns,msg] = optimfcnchk(funstr,caller,lenVarIn,gradflag,constrflag)
%OPTIMFCNCHK Pre- and post-process function expression for FUNCHK.
%
%  
if (nargin < 5)
	constrflag = 0;
	if (nargin < 4)
		gradflag = 0;
	end
end
if (constrflag)
	graderrmsg = 'Constraint gradient function expected but not found.';
	warnstr = 'Ignoring constraint gradient function and using finite-differencing.';
else
	graderrmsg = 'Gradient function expected but not found.';
	warnstr = 'Ignoring gradient function and using finite-differencing.';
end
msg = '';
nonlconmsg =  'NONLCON must be a function.';
allfcns = {};
funfcn = [];
gradfcn = [];
if (gradflag)
	calltype = 'fungrad';
else
	calltype = 'fun';
end
if (isa(funstr,'cell') & (length(funstr) == 1))
	% {fun}
	% take the cellarray apart: we know it is nonempty
	if (gradflag)
		error(graderrmsg)
	end
	[funfcn,msg] = fcnchk(funstr{1},lenVarIn);
	if (~isempty(msg))
		if (constrflag)
			msg = nonlconmsg;
		end
		error(msg)
	end
elseif (isa(funstr,'cell') & (length(funstr) == 2) & isempty(funstr{2}))
	% {fun,[]}      
	if (gradflag)
		error(graderrmsg)
	end
	[funfcn,msg] = fcnchk(funstr{1},lenVarIn);
	if (~isempty(msg))
		if (constrflag)
			msg = nonlconmsg;
		end
		error(msg);
	end  
elseif (isa(funstr,'cell') & (length(funstr) == 2))
	% {fun, grad}   
	[funfcn, msg] = fcnchk(funstr{1},lenVarIn);
	if (~isempty(msg))
		if (constrflag)
			msg = nonlconmsg;
		end
		error(msg);
	end  
	[gradfcn,msg] = fcnchk(funstr{2},lenVarIn);
	if (~isempty(msg))
		if (constrflag)
			msg = nonlconmsg
		end
		error(msg);
	end
	calltype = 'fun_then_grad';
	if (~gradflag)
		warning(warnstr);
		calltype = 'fun';
	end
elseif (~isa(funstr, 'cell'))
	% Not a cell; is a string expression, function name string or inline object
	[funfcn, msg] = fcnchk(funstr,lenVarIn);
	if (~isempty(msg))
		if (constrflag)
			msg = nonlconmsg;
		end
		error(msg);
	end   
	if (gradflag)
		% gradient and function in one function/M-file
		gradfcn = funfcn;
	end  
else
	error('FUN must be a function, a valid string expression, or an inline function object.');
end
allfcns{1} = calltype;
allfcns{2} = caller;
allfcns{3} = funfcn;
allfcns{4} = gradfcn;
return

function [f,msg] = fcnchk(fun,varargin)
%FCNCHK Check FUNFUN function argument.
%
%
msg = '';
nin = nargin;
if (isstr(fun))
	fun = strtrim(fun);
	if (isempty(fun))
		f = inline('[]');
	elseif (isidentifier(fun))
		f = fun;
	else
		f = inline(fun,varargin{1:nin-1});
	end
elseif (isa(fun,'function_handle'))
	f = fun; 
elseif (isobject(fun))
	% is it a MATLAB object with a feval method?
	% delay the methods call unless we know it is an object to avoid runtime error for compiler
	meths = methods(class(fun));
	if (any(strmatch('feval',meths,'exact')))
		f = fun;
	else
		% no feval method
		f = '';
		msg = 'If FUN is a MATLAB object, it must have an feval method.';
	end
else
	f = '';
	msg = 'FUN must be a function, a valid string expression, or an inline function object.';
end
if (nargout < 2)
	error(msg);
end
return

function s1 = strtrim(s)
%STRTRIM Trim spaces from string.
%
%
if (~isempty(s) & ~isstr(s))
	warning('Input must be a string.')
end
if isempty(s)
	s1 = s;
else
	% remove leading and trailing blanks (including nulls)
	c = find((s ~= ' ') & (s ~= 0));
	s1 = s(min(c):max(c));
end
return

function tf = isidentifier(str)
%ISIDENTIFIER
%
%
tf = 0;
if (~isempty(str))
	first = str(1);
	if (isletter(first))
		letters = isletter(str);
		numerals = (48 <= str) & (str <= 57);
		underscore = (95 == str);
		if (all(letters | numerals | underscore))
			tf = 1;
		end
	end
end
tf = (tf~=0);
return

function [x,FVAL,LAGMUL,EXITFLAG,OUTPUT,GRADIENT,HESS] = nlconst(funfcn,x,lb,ub,Ain,Bin,Aeq,Beq,confcn,...
	OPTIONS,defaultopt,verbosity,gradflag,gradconstflag,hessflag,...
	CHG,fval,gval,Hval,ncineqval,nceqval,gncval,gnceqval,varargin)
%NLCONST Helper function to find the constrained minimum of a function 
%   of several variables. Called by CONSTR, ATTGOAL. SEMINF and MINIMAX.
%
%   [X,OPTIONS,LAMBDA,HESS]=NLCONST('FUN',X0,OPTIONS,lb,ub,'GRADFUN',...
%   varargin{:}) starts at X0 and finds a constrained minimum to 
%   the function which is described in FUN. FUN is a four element cell array
%   set up by PREFCNCHK.  It contains the call to the objective/constraint
%   function, the gradients of the objective/constraint functions, the
%   calling type (used by OPTEVAL), and the calling function name. 
%
%   $Revision: 1.4.2.3 $  $Date: 2004/04/04 03:30:40 $
%   Andy Grace 7-9-90, Mary Ann Branch 9-30-96.

%   Called by CONSTR, SEMINF, ATTGOAL, MINIMAX.
%   Calls OPTEVAL.
%

% Initialize so if OPT_STOP these have values
FVAL=[];
lambda=[];
EXITFLAG =1;
OUTPUT=[];
HESS=[];
% Expectations: GRADfcn must be [] if it does not exist.
global OPT_STOP OPT_STEP
iter = 0;
% Set up parameters.
XOUT=x(:);
% numberOfVariables must be the name of this variable
numberOfVariables = length(XOUT);

Nlconst = 'nlconst';
tolX = getgaopt(OPTIONS,'TolX',defaultopt,'fast');
tolFun = getgaopt(OPTIONS,'TolFun',defaultopt,'fast');
tolCon = getgaopt(OPTIONS,'TolCon',defaultopt,'fast');
DiffMinChange = getgaopt(OPTIONS,'DiffMinChange',defaultopt,'fast');
DiffMaxChange = getgaopt(OPTIONS,'DiffMaxChange',defaultopt,'fast');
maxFunEvals = getgaopt(OPTIONS,'MaxFunEvals',defaultopt,'fast');
maxIter = getgaopt(OPTIONS,'MaxIter',defaultopt,'fast');
% In case the defaults were gathered from calling: optimset('fmincon'):
if ischar(maxFunEvals)
	if isequal(lower(maxFunEvals),'100*numberofvariables')
		maxFunEvals = 100*numberOfVariables;
	else
		error('Option ''MaxFunEvals'' must be an integer value if not the default.')
	end
end
% Handle bounds as linear constraints
arglb = ~isinf(lb);
lenlb=length(lb); % maybe less than numberOfVariables due to old code
argub = ~isinf(ub);
lenub=length(ub);
boundmatrix = eye(max(lenub,lenlb),numberOfVariables);

if nnz(arglb) > 0     
	lbmatrix = -boundmatrix(arglb,1:numberOfVariables);% select non-Inf bounds 
	lbrhs = -lb(arglb);
else
	lbmatrix = [];
	lbrhs = [];
end
if nnz(argub) > 0
	ubmatrix = boundmatrix(argub,1:numberOfVariables);
	ubrhs=ub(argub);
else
	ubmatrix = [];
	ubrhs=[];
end 
bestf = Inf; 
if isempty(confcn{1})
	constflag = 0;
else
	constflag = 1;
end
A = [lbmatrix;ubmatrix;Ain];
B = [lbrhs;ubrhs;Bin];
if isempty(A)
	A = zeros(0,numberOfVariables);
	B=zeros(0,1);
end
if isempty(Aeq)
	Aeq = zeros(0,numberOfVariables);
	Beq=zeros(0,1);
end
% Used for semi-infinite optimization:
s = NaN;
POINT =[];
NEWLAMBDA =[];
LAMBDA = [];
NPOINT =[];
FLAG = 2;
OLDLAMBDA = [];

x(:) = XOUT;  % Set x to have user expected size

% Compute the objective function and constraints
f = fval;
nceq = nceqval;  				   % nonlinear constraints only
ncineq = ncineqval;
%c = [Aeq*XOUT-Beq; ceq; A*XOUT-B; c];
non_eq = length(nceq);
non_ineq = length(ncineq);
[lin_eq,Aeqcol] = size(Aeq);
[lin_ineq,Acol] = size(A);  % includes upper and lower
eq = non_eq + lin_eq;
ineq = non_ineq + lin_ineq;
nc = [nceq; ncineq];
ncstr = ineq + eq;
if isempty(f)
	error('FUN must return a non-empty objective function.')
end
% Evaluate gradients and check size
if gradflag | gradconstflag %evaluate analytic gradient
	if gradflag
		gf_user = gval;
	end
	if gradconstflag
		gnc_user = [gnceqval,gncval];   % Don't include A and Aeq yet
	else
		gnc_user = [];
	end
	if isempty(gnc_user) & isempty(nc)
		% Make gc compatible
		gnc = nc';
		gnc_user = nc';
	end % isempty(gnc_user) & isempty(nc)
end
c = [Aeq*XOUT-Beq;nceq;A*XOUT-B;ncineq];
OLDX=XOUT;
OLDC=c;
OLDNC=nc;
OLDgf=zeros(numberOfVariables,1);
gf=zeros(numberOfVariables,1);
OLDAN=zeros(ncstr,numberOfVariables);
LAMBDA=zeros(ncstr,1);
stepsize=1;
header = sprintf(['\n                                     max                      Directional \n',...
		' Iter   F-count      f(x)         constraint    Step-size      derivative   Procedure ']);
formatstr = '%5.0f  %5.0f   %12.6g %12.4g %12.3g    %12.3g   %s  %s';
if verbosity > 1
	disp(header)
end
HESS=eye(numberOfVariables,numberOfVariables);
numFunEvals=1;
numGradEvals=1;
GNEW=1e8*CHG;
%---------------------------------Main Loop-----------------------------
status = 0;
EXITFLAG = 1;
while status ~= 1
	iter = iter + 1;
	%----------------GRADIENTS----------------
	if ~gradconstflag | ~gradflag
		% Finite Difference gradients (even if just checking analytical)
		POINT = NPOINT; 
		oldf = f;
		oldnc = nc;
		len_nc = length(nc);
		ncstr =  lin_eq + lin_ineq + len_nc;     
		FLAG = 0; % For semi-infinite
		gnc = zeros(numberOfVariables, len_nc);  % For semi-infinite
		
		% Try to make the finite differences equal to 1e-8.
		CHG = -1e-8./(GNEW+eps);
		CHG = sign(CHG+eps).*min(max(abs(CHG),DiffMinChange),DiffMaxChange);
		for gcnt=1:numberOfVariables
			if gcnt == numberOfVariables, 
				FLAG = -1; 
			end
			temp = XOUT(gcnt);
			XOUT(gcnt)= temp + CHG(gcnt);
			x(:) =XOUT; 
			if ~gradflag
				f = feval(funfcn{3},x,varargin{:});
				gf(gcnt,1) = (f-oldf)/CHG(gcnt);
			end
			if ~gradconstflag
				if constflag
					[nctmp,nceqtmp] = feval(confcn{3},x,varargin{:});
					nc = [nceqtmp(:); nctmp(:)];
				end
				if ~isempty(nc)
					gnc(gcnt,:) = (nc - oldnc)'/CHG(gcnt); 
				end
			end
			if OPT_STOP
				break;
			end
			XOUT(gcnt) = temp;
			if OPT_STOP
				break;
			end
		end
		% Gradient check
		if gradflag | gradconstflag
			if gradflag
				gf = gf_user;
			end
			if gradconstflag
				gnc = gnc_user;
			end
		end % DerivativeCheck == 1 &  (gradflag | gradconstflag)
		FLAG = 1; % For semi-infinite
		numFunEvals = numFunEvals + numberOfVariables;
		f=oldf;
		nc=oldnc;
	else% gradflag & gradconstflag & no DerivativeCheck 
		gnc = gnc_user;
		gf = gf_user;
	end  
	% Now add in Aeq, and A
	if ~isempty(gnc)
		gc = [Aeq', gnc(:,1:non_eq), A', gnc(:,non_eq+1:non_ineq+non_eq)];
	elseif ~isempty(Aeq) | ~isempty(A)
		gc = [Aeq',A'];
	else
		gc = zeros(numberOfVariables,0);
	end
	AN=gc';
	how='';
	%-------------SEARCH DIRECTION---------------
	% For equality constraints make gradient face in 
	% opposite direction to function gradient.
	for i=1:eq 
		schg=AN(i,:)*gf;
		if schg>0
			AN(i,:)=-AN(i,:);
			c(i)=-c(i);
		end
	end
	if numGradEvals>1  % Check for first call    
		NEWLAMBDA=LAMBDA; 
		[ma,na] = size(AN);
		GNEW=gf+AN'*NEWLAMBDA;
		GOLD=OLDgf+OLDAN'*LAMBDA;
		YL=GNEW-GOLD;
		sdiff=XOUT-OLDX;
		% Make sure Hessian is positive definite in update.
		if YL'*sdiff<stepsize^2*1e-3
			while YL'*sdiff<-1e-5
				[YMAX,YIND]=min(YL.*sdiff);
				YL(YIND)=YL(YIND)/2;
			end
			if YL'*sdiff < (eps*norm(HESS,'fro'));
				how=' Hessian modified twice';
				FACTOR=AN'*c - OLDAN'*OLDC;
				FACTOR=FACTOR.*(sdiff.*FACTOR>0).*(YL.*sdiff<=eps);
				WT=1e-2;
				if max(abs(FACTOR))==0; FACTOR=1e-5*sign(sdiff); end
				while YL'*sdiff < (eps*norm(HESS,'fro')) & WT < 1/eps
					YL=YL+WT*FACTOR;
					WT=WT*2;
				end
			else
				how=' Hessian modified';
			end
		end
		%----------Perform BFGS Update If YL'S Is Positive---------
		if YL'*sdiff>eps
			HESS=HESS ...
				+(YL*YL')/(YL'*sdiff)-((HESS*sdiff)*(sdiff'*HESS'))/(sdiff'*HESS*sdiff);
			% BFGS Update using Cholesky factorization  of Gill, Murray and Wright.
			% In practice this was less robust than above method and slower. 
			%   R=chol(HESS); 
			%   s2=R*S; y=R'\YL; 
			%   W=eye(numberOfVariables,numberOfVariables)-(s2'*s2)\(s2*s2') + (y'*s2)\(y*y');
			%   HESS=R'*W*R;
		else
			how=' Hessian not updated';
		end
	else % First call
		OLDLAMBDA=(eps+gf'*gf)*ones(ncstr,1)./(sum(AN'.*AN')'+eps) ;
	end % if numGradEvals>1
	numGradEvals=numGradEvals+1;
	LOLD=LAMBDA;
	OLDAN=AN;
	OLDgf=gf;
	OLDC=c;
	OLDF=f;
	OLDX=XOUT;
	XN=zeros(numberOfVariables,1);
	GT =c;
	HESS = (HESS + HESS')*0.5;
	% $$$       [SD,lambda1,exitflagqp] = qpopt(HESS,gf,AN,-1.0e10*ones(numberOfVariables+size(AN,1),1),...
	% $$$ 				      [1.0e10*ones(numberOfVariables,1);-GT],XN);
	% $$$       lambda = -lambda1(numberOfVariables+1:end);
	% $$$       howqp = 'ok';
	[SD,lambda,exitflagqp,outputqp,howqp] ...
		= qpsub(HESS,gf,AN,-GT,[],[],XN,eq,-1,Nlconst,size(AN,1),numberOfVariables); 
	lambda((1:eq)') = abs(lambda( (1:eq)' ));
	ga=[abs(c( (1:eq)' )) ; c( (eq+1:ncstr)' ) ];
	if ~isempty(c)
		mg=max(ga);
	else
		mg = 0;
	end
	if strncmp(howqp,'ok',2); 
		howqp =''; 
	end
	if ~isempty(how) & ~isempty(howqp) 
		how = [how,'; '];
	end
	if verbosity > 1
		CurrOutput = sprintf(formatstr,iter,numFunEvals,f,mg,stepsize,gf'*SD,how,howqp); 
		disp(CurrOutput)
	end
	LAMBDA=lambda((1:ncstr)');
	OLDLAMBDA=max([LAMBDA';0.5*(LAMBDA+OLDLAMBDA)'])' ;
	%---------------LINESEARCH--------------------
	MATX=XOUT;
	MATL = f+sum(OLDLAMBDA.*(ga>0).*ga) + 1e-30;
	infeas = strncmp(howqp,'i',1);
	% This merit function looks for improvement in either the constraint
	% or the objective function unless the sub-problem is infeasible in which
	% case only a reduction in the maximum constraint is tolerated.
	% This less "stringent" merit function has produced faster convergence in
	% a large number of problems.
	if mg > 0
		MATL2 = mg;
	elseif f >=0 
		MATL2 = -1/(f+1);
	else 
		MATL2 = 0;
	end
	if ~infeas & f < 0
		MATL2 = MATL2 + f - 1;
	end
	if mg < eps & f < bestf
		bestf = f;
		bestx = XOUT;
		bestHess = HESS;
		bestgrad = gf;
		bestlambda = lambda;
	end
	MERIT = MATL + 1;
	MERIT2 = MATL2 + 1; 
	stepsize=2;
	while ((MERIT2 > MATL2) & (MERIT > MATL) & numFunEvals < maxFunEvals & ~OPT_STOP)
		stepsize=stepsize/2;
		if stepsize < 1e-4,  
			stepsize = -stepsize; 
		end
		XOUT = MATX + stepsize*SD;
		x(:)=XOUT; 
		f = feval(funfcn{3},x,varargin{:});
		if constflag
			[nctmp,nceqtmp] = feval(confcn{3},x,varargin{:});
			nctmp = nctmp(:);
			nceqtmp = nceqtmp(:);
		else
			nctmp = [];
			nceqtmp=[];
		end
		nc = [nceqtmp(:); nctmp(:)];
		c = [Aeq*XOUT-Beq; nceqtmp(:); A*XOUT-B; nctmp(:)];  
		if OPT_STOP
			break;
		end
		numFunEvals = numFunEvals + 1;
		ga=[abs(c( (1:eq)' )) ; c( (eq+1:length(c))' )];
		if ~isempty(c)
			mg=max(ga);
		else
			mg = 0;
		end
		MERIT = f+sum(OLDLAMBDA.*(ga>0).*ga);
		if mg > 0
			MERIT2 = mg;
		elseif f >=0 
			MERIT2 = -1/(f+1);
		else 
			MERIT2 = 0;
		end
		if ~infeas & f < 0
			MERIT2 = MERIT2 + f - 1;
		end
	end
	%------------Finished Line Search-------------
	mf=abs(stepsize);
	LAMBDA=mf*LAMBDA+(1-mf)*LOLD;
	% Test stopping conditions (convergence)
	if (max(abs(SD)) < 2*tolX | abs(gf'*SD) < 2*tolFun ) & ...
			(mg < tolCon | (strncmp(howqp,'i',1) & mg > 0 ) )
		if ~strncmp(howqp, 'i', 1) 
			if verbosity > 0
				disp('Optimization terminated successfully:')
			end 
			if max(abs(SD)) < 2*tolX 
				if verbosity > 0
					disp(' Search direction less than 2*options.TolX and')
					disp('  maximum constraint violation is less than options.TolCon')
				end
			else
				if verbosity > 0
					disp(' Magnitude of directional derivative in search direction ')
					disp('  less than 2*options.TolFun and maximum constraint violation ')
					disp('  is less than options.TolCon')     
				end
			end
			active_const = find(LAMBDA>0);
			if active_const 
				if verbosity > 0
					disp('Active Constraints:'), 
					disp(active_const) 
				end
			else % active_const == 0
				if verbosity > 0
					disp(' No Active Constraints');
				end
			end % active_const
		end % ~strncmp(howqp, 'i', 1)
		if (strncmp(howqp, 'i',1) & mg > 0)
			if verbosity > 0
				disp('Optimization terminated: No feasible solution found.')
			end 
			if max(abs(SD)) < 2*tolX 
				if verbosity > 0
					disp(' Search direction less than 2*options.TolX but constraints are not satisfied.')
				end
			else
				if verbosity > 0
					disp(' Magnitude of directional derivative in search direction ')
					disp('  less than 2*options.TolFun but constraints are not satisfied.')    
				end
			end
			EXITFLAG = -1;   
		end % (strncmp(howqp, 'i',1) & mg > 0)
		status=1;
	else
		% NEED=[LAMBDA>0] | G>0
		if numFunEvals > maxFunEvals  | OPT_STOP
			XOUT = MATX;
			f = OLDF;
			if ~OPT_STOP
				if verbosity > 0
					disp('Maximum number of function evaluations exceeded;')
					disp('increase OPTIONS.MaxFunEvals')
				end
			end
			EXITFLAG = 0;
			status=1;
		end
		if iter > maxIter
			XOUT = MATX;
			f = OLDF;
			if verbosity > 0
				disp('Maximum number of function evaluations exceeded;')
				disp('increase OPTIONS.MaxIter')
			end
			EXITFLAG = 0;
			status=1;
		end
	end 
	x(:) = XOUT;
	switch funfcn{1} % evaluate function gradients
	case 'fun'
		;  % do nothing...will use finite difference.
	case 'fungrad'
		[f,gf_user] = feval(funfcn{3},x,varargin{:});
		gf_user = gf_user(:);
		numGradEvals=numGradEvals+1;
	case 'fun_then_grad'
		gf_user = feval(funfcn{4},x,varargin{:});
		gf_user = gf_user(:);
		numGradEvals=numGradEvals+1;
	otherwise
		error('Undefined calltype in FMINCON');
	end
	numFunEvals=numFunEvals+1;
	% Evaluate constraint gradients
	switch confcn{1}
	case 'fun'
		gnceq=[]; gncineq=[];
	case 'fungrad'
		[nctmp,nceqtmp,gncineq,gnceq] = feval(confcn{3},x,varargin{:});
		nctmp = nctmp(:); nceqtmp = nceqtmp(:);
		numGradEvals=numGradEvals+1;
	case 'fun_then_grad'
		[gncineq,gnceq] = feval(confcn{4},x,varargin{:});
		numGradEvals=numGradEvals+1;
	case ''
		nctmp=[];
		nceqtmp =[];
		gncineq = zeros(numberOfVariables,length(nctmp));
		gnceq = zeros(numberOfVariables,length(nceqtmp));
	otherwise
		error('Undefined calltype in FMINCON');
	end
	gnc_user = [gnceq, gncineq];
	gc = [Aeq', gnceq, A', gncineq];
end
% Update 
numConstrEvals = numGradEvals;
% Gradient is in the variable gf
GRADIENT = gf;
% If a better unconstrained solution was found earlier, use it:
if f > bestf 
	XOUT = bestx;
	f = bestf;
	HESS = bestHess;
	GRADIENT = bestgrad;
	lambda = bestlambda;
end
FVAL = f;
x(:) = XOUT;
if (OPT_STOP)
	if verbosity > 0
		disp('Optimization terminated prematurely by user')
	end
end
OUTPUT.iterations = iter;
OUTPUT.funcCount = numFunEvals;
OUTPUT.stepsize = stepsize;
OUTPUT.algorithm = 'medium-scale: SQP, Quasi-Newton, line-search';
OUTPUT.firstorderopt = [];
OUTPUT.cgiterations = [];

[lin_ineq,Acol] = size(Ain);  % excludes upper and lower
LAGMUL.lower=zeros(lenlb,1);
LAGMUL.upper=zeros(lenub,1);
LAGMUL.eqlin = lambda(1:lin_eq);
ii = lin_eq ;
LAGMUL.eqnonlin = lambda(ii+1:ii+non_eq);
ii = ii+non_eq;
LAGMUL.lower(arglb) = lambda(ii+1:ii+nnz(arglb));
ii = ii + nnz(arglb) ;
LAGMUL.upper(argub) = lambda(ii+1:ii+nnz(argub));
ii = ii + nnz(argub);
LAGMUL.ineqlin = lambda(ii+1:ii+lin_ineq);
ii = ii + lin_ineq ;
LAGMUL.ineqnonlin = lambda(ii+1:end);
return

function [X,lambda,exitflag,output,how]=qpsub(H,f,A,B,lb,ub,X,neqcstr,verbosity,caller,ncstr,numberOfVariables,options,defaultopt)
%QP Quadratic programming subproblem. Handles qp and constrained
%   linear least-squares as well as subproblems generated from NLCONST.
%
%   X=QP(H,f,A,b) solves the quadratic programming problem:
%
%            min 0.5*x'Hx + f'x   subject to:  Ax <= b 
%             x    
%

%   $Revision: 1.4.2.3 $  $Date: 2004/04/04 03:30:40 $
%   Andy Grace 7-9-90. Mary Ann Branch 9-30-96.

% Define constant strings
NewtonStep = 'Newton';
SteepDescent = 'steepest descent';
Conls = 'lsqlin';
Lp = 'linprog';
Qp = 'quadprog';
Qpsub = 'qpsub';
how = 'ok'; 
exitflag = 1;
output = [];
iterations = 0;
if nargin < 13
	options = [];
end
lb=lb(:);
ub = ub(:);
msg = nargchk(12,12,nargin);
if isempty(verbosity), verbosity = 1; end
if isempty(neqcstr), neqcstr = 0; end
LLS = 0;
if strcmp(caller, Conls)
	LLS = 1;
	[rowH,colH]=size(H);
	numberOfVariables = colH;
end
if strcmp(caller, Qpsub)
	normalize = -1;
else
	normalize = 1;
end
simplex_iter = 0;
if  norm(H,'inf')==0 | isempty(H), is_qp=0; else, is_qp=1; end
if LLS==1
	is_qp=0;
end
normf = 1;
if normalize > 0
	% Check for lp
	if ~is_qp & ~LLS
		normf = norm(f);
		if normf > 0
			f = f./normf;
		end
	end
end
% Handle bounds as linear constraints
arglb = ~eq(lb,-inf);
lenlb=length(lb); % maybe less than numberOfVariables due to old code
if nnz(arglb) > 0     
	lbmatrix = -eye(lenlb,numberOfVariables);
	A=[A; lbmatrix(arglb,1:numberOfVariables)]; % select non-Inf bounds
	B=[B;-lb(arglb)];
end
argub = ~eq(ub,inf);
lenub=length(ub);
if nnz(argub) > 0
	ubmatrix = eye(lenub,numberOfVariables);
	A=[A; ubmatrix(argub,1:numberOfVariables)];
	B=[B; ub(argub)];
end 
ncstr=ncstr + nnz(arglb) + nnz(argub);
% Figure out max iteration count
% For now, limit the iterations when qpsub is called from nlconst
maxiter = 200*numberOfVariables;

% Used for determining threshold for whether a direction will violate
% a constraint.
normA = ones(ncstr,1);
if normalize > 0 
	for i=1:ncstr
		n = norm(A(i,:));
		if (n ~= 0)
			A(i,:) = A(i,:)/n;
			B(i) = B(i)/n;
			normA(i,1) = n;
		end
	end
else 
	normA = ones(ncstr,1);
end
errnorm = 0.01*sqrt(eps); 
tolDep = 100*numberOfVariables*eps;      
lambda=zeros(ncstr,1);
aix=lambda;
ACTCNT=0;
ACTSET=[];
ACTIND=0;
CIND=1;
eqix = 1:neqcstr; 
%------------EQUALITY CONSTRAINTS---------------------------
Q = zeros(numberOfVariables,numberOfVariables);
R = []; 
indepInd = 1:ncstr; 
if neqcstr>0
	% call equality constraint solver
	[Q,R,A,B,CIND,X,Z,actlambda,how,...
			ACTSET,ACTIND,ACTCNT,aix,eqix,neqcstr,ncstr,remove,exitflag]= ...
		eqnsolv(A,B,eqix,neqcstr,ncstr,numberOfVariables,LLS,H,X,f,normf,normA,verbosity, ...
		aix,how,exitflag);   
	if ~isempty(remove)
		indepInd(remove)=[];
		normA = normA(indepInd);
	end
	if ACTCNT >= numberOfVariables - 1  
		simplex_iter = 1; 
	end
	[m,n]=size(ACTSET);
	if strcmp(how,'infeasible')
		% Equalities are inconsistent, so X and lambda have no valid values
		% Return original X and zeros for lambda.
		output.iterations = iterations;
		return
	end
	err = 0;
	if neqcstr > numberOfVariables
		err = max(abs(A(eqix,:)*X-B(eqix)));
		if (err > 1e-8)  % Equalities not met
			how='infeasible';
			% was exitflag = 7; 
			exitflag = -1;
			if verbosity > 0 
				disp('Exiting: The equality constraints are overly stringent;')
				disp('         there is no feasible solution.')
			end
			% Equalities are inconsistent, X and lambda have no valid values
			% Return original X and zeros for lambda.
			output.iterations = iterations;
			return
		else % Check inequalities
			if (max(A*X-B) > 1e-8)
				how = 'infeasible';
				% was exitflag = 8; 
				exitflag = -1;
				if verbosity > 0
					disp('Exiting: The constraints or bounds are overly stringent;')
					disp('         there is no feasible solution.')
					disp('         Equality constraints have been met.')
				end
			end
		end
		if is_qp
			actlambda = -R\(Q'*(H*X+f));
		elseif LLS
			actlambda = -R\(Q'*(H'*(H*X-f)));
		else
			actlambda = -R\(Q'*f);
		end
		lambda(indepInd(eqix)) = normf * (actlambda ./normA(eqix));
		output.iterations = iterations;
		return
	end
	if isempty(Z)
		if is_qp
			actlambda = -R\(Q'*(H*X+f));
		elseif LLS
			actlambda = -R\(Q'*(H'*(H*X-f)));
		else
			actlambda = -R\(Q'*f);
		end
		lambda(indepInd(eqix)) = normf * (actlambda./normA(eqix));
		if (max(A*X-B) > 1e-8)
			how = 'infeasible';
			% was exitflag = 8; 
			exitflag = -1;
			if verbosity > 0
				disp('Exiting: The constraints or bounds are overly stringent;')
				disp('         there is no feasible solution.')
				disp('         Equality constraints have been met.')
			end
		end
		output.iterations = iterations;
		return
	end
	% Check whether in Phase 1 of feasibility point finding. 
	if (verbosity == -2)
		cstr = A*X-B; 
		mc=max(cstr(neqcstr+1:ncstr));
		if (mc > 0)
			X(numberOfVariables) = mc + 1;
		end
	end
else
	Z=1;
end
% Find Initial Feasible Solution
cstr = A*X-B;
mc=max(cstr(neqcstr+1:ncstr));
if mc>eps
	A2=[[A;zeros(1,numberOfVariables)],[zeros(neqcstr,1);-ones(ncstr+1-neqcstr,1)]];
	quiet = -2;
	[XS,lambdaS,exitflagS,outputS] = qpsub([],[zeros(numberOfVariables,1);1],A2,[B;1e-5], ...
		[],[],[X;mc+1],neqcstr,quiet,Qpsub,size(A2,1),numberOfVariables+1);
	X=XS(1:numberOfVariables);
	cstr=A*X-B;
	if XS(numberOfVariables+1)>eps 
		if XS(numberOfVariables+1)>1e-8 
			how='infeasible';
			% was exitflag = 4; 
			exitflag = -1;
			if verbosity > 0
				disp('Exiting: The constraints are overly stringent;')
				disp('         no feasible starting point found.')
			end
		else
			how = 'overly constrained';
			% was exitflag = 3; 
			exitflag = -1;
			if verbosity > 0
				disp('Exiting: The constraints are overly stringent;')
				disp(' initial feasible point found violates constraints ')
				disp(' by more than eps.');
			end
		end
		lambda(indepInd) = normf * (lambdaS((1:ncstr)')./normA);
		output.iterations = iterations;
		return
	end
end
if (is_qp)
	gf=H*X+f;
	%  SD=-Z*((Z'*H*Z)\(Z'*gf));
	[SD, dirType] = compdir(Z,H,gf,numberOfVariables,f);
	% Check for -ve definite problems:
	%  if SD'*gf>0, is_qp = 0; SD=-SD; end
elseif (LLS)
	HXf=H*X-f;
	gf=H'*(HXf);
	HZ= H*Z;
	[mm,nn]=size(HZ);
	if mm >= nn
		%   SD =-Z*((HZ'*HZ)\(Z'*gf));
		[QHZ, RHZ] =  qr(HZ,0);
		Pd = QHZ'*HXf;
		% Now need to check which is dependent
		if min(size(RHZ))==1 % Make sure RHZ isn't a vector
			depInd = find( abs(RHZ(1,1)) < tolDep);
		else
			depInd = find( abs(diag(RHZ)) < tolDep );
		end  
	end
	if mm >= nn & isempty(depInd) % Newton step
		SD = - Z*(RHZ(1:nn, 1:nn) \ Pd(1:nn,:));
		dirType = NewtonStep;
	else % steepest descent direction
		SD = -Z*(Z'*gf);
		dirType = SteepDescent;
	end
else % lp
	gf = f;
	SD=-Z*Z'*gf;
	dirType = SteepDescent; 
	if norm(SD) < 1e-10 & neqcstr
		% This happens when equality constraint is perpendicular
		% to objective function f.x.
		actlambda = -R\(Q'*(gf));
		lambda(indepInd(eqix)) = normf * (actlambda ./ normA(eqix));
		output.iterations = iterations;
		return;
	end
end
oldind = 0; 
% The maximum number of iterations for a simplex type method is when ncstr >=n:
% maxiters = prod(1:ncstr)/(prod(1:numberOfVariables)*prod(1:max(1,ncstr-numberOfVariables)));
%--------------Main Routine-------------------
while iterations < maxiter
	iterations = iterations + 1;
	if isinf(verbosity)
		curr_out = sprintf('Iter: %5.0f, Active: %5.0f, step: %s, proc: %s',iterations,ACTCNT,dirType,how);
		disp(curr_out); 
	end
	% Find distance we can move in search direction SD before a 
	% constraint is violated.
	% Gradient with respect to search direction.
	GSD=A*SD;
	% Note: we consider only constraints whose gradients are greater
	% than some threshold. If we considered all gradients greater than 
	% zero then it might be possible to add a constraint which would lead to
	% a singular (rank deficient) working set. The gradient (GSD) of such
	% a constraint in the direction of search would be very close to zero.
	indf = find((GSD > errnorm * norm(SD))  &  ~aix);
	if isempty(indf) % No constraints to hit
		STEPMIN=1e16;
		dist=[];
		ind2=[];
		ind=[];
	else % Find distance to the nearest constraint
		dist = abs(cstr(indf)./GSD(indf));
		[STEPMIN,ind2] =  min(dist);
		ind2 = find(dist == STEPMIN);
		% Bland's rule for anti-cycling: if there is more than one 
		% blocking constraint then add the one with the smallest index.
		ind=indf(min(ind2));
		% Non-cycling rule:
		% ind = indf(ind2(1));
	end
	%-----Update X-------------
	% Assume we do not delete a constraint
	delete_constr = 0;   
	if ~isempty(indf)& isfinite(STEPMIN) % Hit a constraint
		if strcmp(dirType, NewtonStep)
			% Newton step and hit a constraint: LLS or is_qp
			if STEPMIN > 1  % Overstepped minimum; reset STEPMIN
				STEPMIN = 1;
				delete_constr = 1;
			end
			X = X+STEPMIN*SD;
		else
			% Not a Newton step and hit a constraint: is_qp or LLS or maybe lp
			X = X+STEPMIN*SD;          
		end              
	else %  isempty(indf) | ~isfinite(STEPMIN)
		% did not hit a constraint
		if strcmp(dirType, NewtonStep)
			% Newton step and no constraint hit: LLS or maybe is_qp
			STEPMIN = 1;   % Exact distance to the solution. Now delete constr.
			X = X + SD;
			delete_constr = 1;
		else % Not a Newton step: is_qp or lp or LLS
			if is_qp
				% Is it semi-def, neg-def or indef?
				eigoptions.disp = 0;
				ZHZ = Z'*H*Z;
				if numberOfVariables < 400 % only use EIGS on large problems
					[VV,DD] = eig(ZHZ);
					[smallRealEig, eigind] = min(diag(DD));
					ev = VV(:,eigind(1));
				else
					[ev,smallRealEig,flag] = eigs(ZHZ,1,'sr',eigoptions);
					if flag  % Call to eigs failed
						[VV,DD] = eig(ZHZ);
						[smallRealEig, eigind] = min(diag(DD));
						ev = VV(:,eigind(1));
					end
				end
			else % define smallRealEig for LLS
				smallRealEig=0;
			end
			if (~is_qp & ~LLS) | (smallRealEig < -100*eps) % LP or neg def: not LLS
				% neg def -- unbounded
				if norm(SD) > errnorm
					if normalize < 0
						STEPMIN=abs((X(numberOfVariables)+1e-5)/(SD(numberOfVariables)+eps));
					else 
						STEPMIN = 1e16;
					end
					X=X+STEPMIN*SD;
					how='unbounded'; 
					% was exitflag = 5; 
					exitflag = -1;
				else % norm(SD) <= errnorm
					how = 'ill posed';
					% was exitflag = 6; 
					exitflag = -1;
				end
				if verbosity > 0
					if norm(SD) > errnorm
						disp('Exiting: The solution is unbounded and at infinity;')
						disp('         the constraints are not restrictive enough.') 
					else
						disp('Exiting: The search direction is close to zero; ')
						disp('      the problem is ill-posed.')
						disp('      The gradient of the objective function may be zero')
						disp('         or the problem may be badly conditioned.')
					end
				end % if verbosity > 0
				output.iterations = iterations;
				return
			else % singular: solve compatible system for a solution: is_qp or LLS
				if is_qp
					projH = Z'*H*Z; 
					Zgf = Z'*gf;
					projSD = pinv(projH)*(-Zgf);
				else % LLS
					projH = HZ'*HZ; 
					Zgf = Z'*gf;
					projSD = pinv(projH)*(-Zgf);
				end
				% Check if compatible
				if norm(projH*projSD+Zgf) > 10*eps*(norm(projH) + norm(Zgf))
					% system is incompatible --> it's a "chute": use SD from compdir
					% unbounded in SD direction
					if norm(SD) > errnorm
						if normalize < 0
							STEPMIN=abs((X(numberOfVariables)+1e-5)/(SD(numberOfVariables)+eps));
						else 
							STEPMIN = 1e16;
						end
						X=X+STEPMIN*SD;
						how='unbounded'; 
						% was exitflag = 5;
						exitflag = -1;
					else % norm(SD) <= errnorm
						how = 'ill posed';
						%was exitflag = 6;
						exitflag = -1;
					end
					if verbosity > 0
						if norm(SD) > errnorm
							disp('Exiting: The solution is unbounded and at infinity;')
							disp('         the constraints are not restrictive enough.') 
						else
							disp('Exiting: The search direction is close to zero; ')
							disp('      the problem is ill-posed.')
							disp('      The gradient of the objective function may be zero')
							disp('         or the problem may be badly conditioned.')
						end
					end % if verbosity > 0
					output.iterations = iterations;
					return
				else % Convex -- move to the minimum (compatible system)
					SD = Z*projSD;
					dirType = 'singular';
					% First check if constraint is violated.
					GSD=A*SD;
					indf = find((GSD > errnorm * norm(SD))  &  ~aix);
					if isempty(indf) % No constraints to hit
						STEPMIN=1;
						delete_constr = 1;
						dist=[]; ind2=[]; ind=[];
					else % Find distance to the nearest constraint
						dist = abs(cstr(indf)./GSD(indf));
						[STEPMIN,ind2] =  min(dist);
						ind2 = find(dist == STEPMIN);
						% Bland's rule for anti-cycling: if there is more than one 
						% blocking constraint then add the one with the smallest index.
						ind=indf(min(ind2));
					end
					if STEPMIN > 1  % Overstepped minimum; reset STEPMIN
						STEPMIN = 1;
						delete_constr = 1;
					end
					X = X + STEPMIN*SD; 
				end
			end % if ~is_qp | smallRealEig < -eps
		end % if strcmp(dirType, NewtonStep)
	end % if ~isempty(indf)& isfinite(STEPMIN) % Hit a constraint
	if delete_constr
		% Note: only reach here if a minimum in the current subspace found
		if ACTCNT>0
			if ACTCNT>=numberOfVariables-1, 
				% Avoid case when CIND is greater than ACTCNT
				if CIND <= ACTCNT
					ACTSET(CIND,:)=[];
					ACTIND(CIND)=[]; 
				end
			end
			if is_qp
				rlambda = -R\(Q'*(H*X+f));
			elseif LLS
				rlambda = -R\(Q'*(H'*(H*X-f)));
				% else: lp does not reach this point
			end
			actlambda = rlambda;
			actlambda(eqix) = abs(rlambda(eqix));
			indlam = find(actlambda < 0);
			if (~length(indlam)) 
				lambda(indepInd(ACTIND)) = normf * (rlambda./normA(ACTIND));
				output.iterations = iterations;
				return
			end
			% Remove constraint
			lind = find(ACTIND == min(ACTIND(indlam)));
			lind=lind(1);
			ACTSET(lind,:) = [];
			aix(ACTIND(lind)) = 0;
			[Q,R]=qrdelete(Q,R,lind);
			ACTIND(lind) = [];
			ACTCNT = ACTCNT - 2;
			simplex_iter = 0;
			ind = 0;
		else % ACTCNT == 0
			output.iterations = iterations;
			return
		end
		delete_constr = 0;
	end
	% Calculate gradient w.r.t objective at this point
	if is_qp
		gf=H*X+f;
	elseif LLS % LLS
		gf=H'*(H*X-f);
		% else gf=f still true.
	end
	% Update X and calculate constraints
	cstr = A*X-B;
	cstr(eqix) = abs(cstr(eqix));
	% Check no constraint is violated
	if normalize < 0 
		if X(numberOfVariables,1) < eps
			output.iterations = iterations;
			return;
		end
	end
	if max(cstr) > 1e5 * errnorm
		if max(cstr) > norm(X) * errnorm 
			if ( verbosity > 0 ) & ( exitflag == 1 )
				disp('Note: The problem is badly conditioned;')
				disp('         the solution may not be reliable') 
				% verbosity = 0;
			end
			how='unreliable'; 
			% exitflag = 2;
			exitflag = -1;
			if 0
				X=X-STEPMIN*SD;
				output.iterations = iterations;
				return
			end
		end
	end
	if ind % Hit a constraint
		aix(ind)=1;
		ACTSET(CIND,:)=A(ind,:);
		ACTIND(CIND)=ind;
		[m,n]=size(ACTSET);
		[Q,R] = qrinsert(Q,R,CIND,A(ind,:)');
	end
	if oldind 
		aix(oldind) = 0; 
	end
	if ~simplex_iter
		% Z = null(ACTSET);
		[m,n]=size(ACTSET);
		Z = Q(:,m+1:n);
		ACTCNT=ACTCNT+1;
		if ACTCNT == numberOfVariables - 1, simplex_iter = 1; end
		CIND=ACTCNT+1;
		oldind = 0; 
	else
		rlambda = -R\(Q'*gf);
		if isinf(rlambda(1)) & rlambda(1) < 0 
			fprintf('         Working set is singular; results may still be reliable.\n');
			[m,n] = size(ACTSET);
			rlambda = -(ACTSET + sqrt(eps)*randn(m,n))'\gf;
		end
		actlambda = rlambda;
		actlambda(eqix)=abs(actlambda(eqix));
		indlam = find(actlambda<0);
		if length(indlam)
			if STEPMIN > errnorm
				% If there is no chance of cycling then pick the constraint 
				% which causes the biggest reduction in the cost function. 
				% i.e the constraint with the most negative Lagrangian 
				% multiplier. Since the constraints are normalized this may 
				% result in less iterations.
				[minl,CIND] = min(actlambda);
			else
				% Bland's rule for anti-cycling: if there is more than one 
				% negative Lagrangian multiplier then delete the constraint
				% with the smallest index in the active set.
				CIND = find(ACTIND == min(ACTIND(indlam)));
			end
			[Q,R]=qrdelete(Q,R,CIND);
			Z = Q(:,numberOfVariables);
			oldind = ACTIND(CIND);
		else
			lambda(indepInd(ACTIND))= normf * (rlambda./normA(ACTIND));
			output.iterations = iterations;
			return
		end
	end %if ACTCNT<numberOfVariables
	if (is_qp)
		Zgf = Z'*gf; 
		if ~isempty(Zgf) & (norm(Zgf) < 1e-15) 
			SD = zeros(numberOfVariables,1); 
		else
			[SD, dirType] = compdir(Z,H,gf,numberOfVariables,f);
		end
	elseif (LLS)
		Zgf = Z'*gf;
		HZ = H*Z;
		if (norm(Zgf) < 1e-15)
			SD = zeros(numberOfVariables,1);
		else
			HXf=H*X-f;
			gf=H'*(HXf);
			[mm,nn]=size(HZ);
			if mm >= nn
				[QHZ, RHZ] =  qr(HZ,0);
				Pd = QHZ'*HXf;
				% SD = - Z*(RHZ(1:nn, 1:nn) \ Pd(1:nn,:));
				% Now need to check which is dependent
				if min(size(RHZ))==1 % Make sure RHZ isn't a vector
					depInd = find( abs(RHZ(1,1)) < tolDep);
				else
					depInd = find( abs(diag(RHZ)) < tolDep );
				end  
			end
			if mm >= nn & isempty(depInd) % Newton step
				SD = - Z*(RHZ(1:nn, 1:nn) \ Pd(1:nn,:));
				dirType = NewtonStep;
			else % steepest descent direction
				SD = -Z*(Z'*gf);
				dirType = SteepDescent;
			end
		end
	else % LP
		if ~simplex_iter
			SD = -Z*(Z'*gf);
			gradsd = norm(SD);
		else
			gradsd = Z'*gf;
			if  gradsd > 0
				SD = -Z;
			else
				SD = Z;
			end
		end
		if abs(gradsd) < 1e-10  % Search direction null
			% Check whether any constraints can be deleted from active set.
			% rlambda = -ACTSET'\gf;
			if ~oldind
				rlambda = -R\(Q'*gf);
			end
			actlambda = rlambda;
			actlambda(1:neqcstr) = abs(actlambda(1:neqcstr));
			indlam = find(actlambda < errnorm);
			lambda(indepInd(ACTIND)) = normf * (rlambda./normA(ACTIND));
			if ~length(indlam)
				output.iterations = iterations;
				return
			end
			cindmax = length(indlam);
			cindcnt = 0;
			newactcnt = 0;
			while (abs(gradsd) < 1e-10) & (cindcnt < cindmax)
				cindcnt = cindcnt + 1;
				if oldind
					% Put back constraint which we deleted
					[Q,R] = qrinsert(Q,R,CIND,A(oldind,:)');
				else
					simplex_iter = 0;
					if ~newactcnt
						newactcnt = ACTCNT - 1;
					end
				end
				CIND = indlam(cindcnt);
				oldind = ACTIND(CIND);
				[Q,R]=qrdelete(Q,R,CIND);
				[m,n]=size(ACTSET);
				Z = Q(:,m:n);
				if m ~= numberOfVariables
					SD = -Z*Z'*gf;
					gradsd = norm(SD);
				else
					gradsd = Z'*gf;
					if  gradsd > 0
						SD = -Z;
					else
						SD = Z;
					end
				end
			end
			if abs(gradsd) < 1e-10  % Search direction still null
				output.iterations = iterations;
				return;
			end
			lambda = zeros(ncstr,1);
			if newactcnt 
				ACTCNT = newactcnt;
			end
		end
	end
	if simplex_iter & oldind
		% Avoid case when CIND is greater than ACTCNT
		if CIND <= ACTCNT
			ACTIND(CIND)=[];
			ACTSET(CIND,:)=[];
			CIND = numberOfVariables;
		end
	end 
end % while 1
if iterations > maxiter
	exitflag = 0;
	how = 'ill-conditioned';   
end
output.iterations = iterations;
return

function[Q,R,A,B,CIND,X,Z,actlambda,how,...
		ACTSET,ACTIND,ACTCNT,aix,eqix,neqcstr,ncstr,remove,exitflag]= ...
	eqnsolv(A,B,eqix,neqcstr,ncstr,numberOfVariables,LLS,H,X,f,normf,normA,verbosity, ...
	aix,how,exitflag)
% EQNSOLV Helper function for QPSUB.
%    Finds a feasible point with respect to the equality constraints.
%    If the equalities are dependent but not consistent, warning
%    messages are given. If the equalities are dependent but consistent, 
%    the redundant constraints are removed and the corresponding variables 
%    adjusted.

% set tolerances
tolDep = 100*numberOfVariables*eps;      
tolCons = 1e-10;

actlambda = [];
aix(eqix)=ones(neqcstr,1);
ACTSET=A(eqix,:);
ACTIND=eqix;
ACTCNT=neqcstr;
CIND=neqcstr+1;
Z=[];
Anew=[];
Bnew=[];
remove =[];
% See if the equalities form a consistent system:
%   QR factorization of A
[Qa,Ra,Ea]=qr(A(eqix,:));
% Now need to check which is dependent
if min(size(Ra))==1 % Make sure Ra isn't a vector
	depInd = find( abs(Ra(1,1)) < tolDep);
else
	depInd = find( abs(diag(Ra)) < tolDep );
end
if neqcstr > numberOfVariables
	depInd = [depInd; ((numberOfVariables+1):neqcstr)'];
end      
if ~isempty(depInd)
	if verbosity > 0
		disp('The equality constraints are dependent.')
	end
	how='dependent';
	exitflag = 1;
	bdepInd =  abs(Qa(:,depInd)'*B(eqix)) >= tolDep ;
	if any( bdepInd ) % Not consistent
		how='infeasible';   
		exitflag = 9;exitflag = -1;
		if verbosity > 0
			disp('The system of equality constraints is not consistent.');
			if ncstr > neqcstr
				disp('The inequality constraints may or may not be satisfied.');
			end
			disp('  There is no feasible solution.')
		end
	else % the equality constraints are consistent
		numDepend = nnz(depInd);
		% delete the redundant constraints:
		% By QR factoring the transpose, we see which columns of A'
		%   (rows of A) move to the end
		[Qat,Rat,Eat]=qr(ACTSET');        
		[i,j] = find(Eat); % Eat permutes the columns of A' (rows of A)
		remove = i(depInd);
		if verbosity > 0
			disp('The system of equality constraints is consistent. Removing');
			disp('the following dependent constraints before continuing:');
			disp(remove)
		end
		A(eqix(remove),:)=[];
		B(eqix(remove))=[];
		neqcstr = neqcstr - nnz(remove);
		ncstr = ncstr - nnz(remove);
		eqix = 1:neqcstr;
		aix=[ones(neqcstr,1); zeros(ncstr-neqcstr,1)];
		ACTIND = eqix;
		ACTSET=A(eqix,:);
		CIND = neqcstr+1;
		ACTCNT = neqcstr;
	end % consistency check
end % dependency check
if ~strcmp(how,'infeasible')
	% Find a feasible point
	if max(abs(A(eqix,:)*X-B(eqix))) > tolCons
		X = A(eqix,:)\B(eqix);  
	end
end
[Q,R]=qr(ACTSET');
Z = Q(:,neqcstr+1:numberOfVariables);
return

function [SD, dirType] = compdir(Z,H,gf,nvars,f);
% COMPDIR Computes a search direction in a subspace defined by Z. 
%    Helper function for NLCONST.
%    Returns Newton direction if possible.
%    Returns random direction if gradient is small.
%    Otherwise, returns steepest descent direction.  
%    If the steepest descent direction is small it computes a negative
%    curvature direction based on the most negative eigenvalue.
%    For singular matrices, returns steepest descent even if small.

%   $Revision: 1.4.2.3 $  $Date: 2004/04/04 03:30:40 $
%   Mary Ann Branch 10-20-96.

% Define constant strings
Newton = 'Newton';
Random = 'random';
SteepDescent = 'steepest descent';
Eigenvector = 'eigenvector';

%  SD=-Z*((Z'*H*Z)\(Z'*gf));
dirType = [];
% Compute the projected Newton direction if possible
projH = Z'*H*Z;
[R, p] = chol(projH);
if ~p  % positive definite: use Newton direction
	SD = - Z*(R \ ( R'\(Z'*gf)));
	dirType = Newton;
else % not positive definite
	% If the gradient is small, try a random direction:
	% Sometimes the search direction goes to zero in negative
	% definite problems when the current point rests on
	% the top of the quadratic function. In this case we can move in
	% any direction to get an improvement in the function so 
	% foil search direction by giving a random gradient.
	if norm(gf) < sqrt(eps)
		SD = -Z*Z'*(rand(nvars,1) - 0.5);
		dirType = Random;
	else
		% steepest descent
		stpDesc = - Z*(Z'*gf);
		% check if ||SD|| is close to zero 
		if norm(stpDesc) > sqrt(eps)       
			SD = stpDesc;
			dirType = SteepDescent;
		else
			% Look for a negative curvature direction
			%  Some attempt at efficiency: usually it's
			%  faster to use EIG unless many variables.
			if nvars < 400  
				[VV,DD] = eig(projH);
				[smallRealEig, eigind] = min(diag(DD));
				ev = VV(:,eigind(1));
			else
				options.disp = 0;
				[ev, smallRealEig, flag] = eigs(projH,1,'sr',options);
				if flag  % Call to eigs failed
					[VV,DD] = eig(projH);
					[smallRealEig, eigind] = min(diag(DD));
					ev = VV(:,eigind(1));
				end
			end
			if smallRealEig < 0
				% check the sign of SD and the magnitude.
				SDtol = 100*eps*norm(gf); % Note: we know norm(gf) > sqrt(eps)
				Zev = Z*ev;
				if Zev'*gf > SDtol
					SD = -Zev;
					dirType = Eigenvector;
				elseif Zev'*gf < SDtol
					SD = Zev;
					dirType = Eigenvector;
				else % 
					SD = stpDesc;
					dirType = SteepDescent; 
				end
			else
				% The projected Hessian is singular,i.e., zero direction is ok
				%  -- will propagate thru the algorithm.
				SD = stpDesc;
				dirType = SteepDescent; 
			end % smallRealEig < 0
		end % randSD'*(gf) < -SDtol
	end %  norm(stpDesc) > sqrt(eps)  
end % ~p
return
