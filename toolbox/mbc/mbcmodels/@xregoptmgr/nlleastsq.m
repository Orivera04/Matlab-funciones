function F= nlleastsq(F,m);
% FITALGORITHM/NLLEASTSQ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:56:51 $

% function handles to run and setup functions
F.RunFcn   = @i_FitModel;

% Options which user can change
F= AddOption(F,'GradObj','off','on|off','',0);
F= AddOption(F,'Jacobian','on','on|off','',0);
F= AddOption(F,'LargeScale','on','on|off','',0);
F= AddOption(F,'JacobPattern',[],'sparse','',0);
F= AddOption(F,'TypicalX',[],'numeric','',0);
F= AddOption(F,'PrecondBandWidth',0,{'int',[0,Inf]},'',0);

% These options can be change by the optimisation manger's GUI setp
F= AddOption(F,'Display','none','none|iter|final','',1);
F= AddOption(F,'MaxFunEvals',1000,{'int',[1 Inf]},'Max. Function Evaluations',1);
F= AddOption(F,'MaxIter',100,{'int',[1 Inf]},'Max. Iterations',1);
F= AddOption(F,'TolFun',1e-6,{'numeric',[1e-12 Inf]},'Function Tolerance',1);
F= AddOption(F,'TolX',1e-6,{'numeric',[1e-12 Inf]},'Variable Tolerance',1);
F= AddOption(F,'MaxError',10,{'numeric',[0 Inf]},'Max. Error',1);
F= AddOption(F,'ScaleResiduals',1,'boolean','Scale Residuals',1);

F.name= 'Nonlinear least squares';

% function [UpdatedContextObj,costFcn,OK,varargout] = optimRunFcnTmpl(omgr,ContextObj,InitVals,varargin)
function [m,cost,OK,xf,res,J] = i_FitModel(m,F,x0,x,y,varargin)

% get model constraints

% do we want a constraints manager class to do this

[LB,UB,A,c,nlfunc]= getConstraints(F);

% Put Optimisation ToolBox parameters and values into a cell matrix
otbxParam= [{F.foptions(1:end-2).Param} ; {F.foptions(1:end-2).Value}];

if get(F,'ScaleResiduals')
	c0=  sqrt( ssenonlin(x0,F,1,m,x,y,[],varargin{:}) );
    if c0==0
        % try the norm of y data
        c0= sqrt(y'*y);
        if c0==0
            % use 1
            c0=1;
        end
    end
    
    % c0 = c0/sqrt(size(y,1));
    x0=x0(:);
    sx= abs(x0);
    tol= max(sx)*1e-8;
    sx(sx < max(sx)*1e-8 )= 1;
    
    sx= 10.^( floor(log10(sx)) ) ;
    if max(sx)/min(sx)>1e3
         % scale if range of parameters too great
        x0= x0./sx;
        % scale constraints
        if ~isempty(A)
            nv=length(x0);
            A= A*spdiags(sx,0,nv,nv);
        end
        if ~isempty(LB)
            LB= LB./sx;
        end
        if ~isempty(UB)
            UB= UB./sx;
        end
    else
        sx=[];
    end
else
    c0=1;
    sx= [];
end


if isempty(A) & isempty(c) & isempty(nlfunc)
   % use lsqnonlin 
	lsq=1;
   
	
   fopts= optimset(optimset('lsqnonlin'),...
		otbxParam{:});
	
	if ~isempty(LB) | ~isempty(UB)
		fopts= optimset(fopts,'largescale','on');
	end
	[xf,cost,res,flag]= lsqnonlin(@lsqerrors,x0,LB,UB,fopts,F,c0,m,x,y,sx,varargin{:});
	
else
    % use fmincon
    if ~isempty(nlfunc);
        nlfunc= @i_nlconstraints;
    end
    
    lsq=0;
    fopts= optimset(optimset('fmincon'),...
        otbxParam{:},...
        'largescale','off',...
        'MaxSQPIter',1000,...
        'HessPattern',ones(size(x0)));
    
    [xf,cost,flag]= fmincon(@ssenonlin,x0,A,c,[],[],LB,UB,nlfunc,fopts,F,c0,m,x,y,sx,varargin{:});
end
if nargout>4
   [res,J,OK]= lsqerrors(xf,F,1,m,x,y,sx,varargin{:});
else
   OK=1;
end

if ~isempty(sx)
    % scale final results
    xf= sx.*xf;
end

% final unscaled cost
cost= cost*c0^2;

OK= all(OK) & flag >= 0;


% Sum of squares error
function [cost,g]= ssenonlin(B,F,c0,m,x,y,sx,varargin)


if nargout==1
	res= lsqerrors(B,F,c0,m,x,y,sx,varargin{:});
else
	[res,J]= lsqerrors(B,F,c0,m,x,y,sx,varargin{:});
	
   g= 2*res'*J;
   if ~all(isfinite(g))
      ind= any(isfinite(J),2) | isfinite(res);
      g= 2*res(ind)'*J(ind,:);
   end
   
end	

cost = res'*res;

% residual function
function [res,J,ok]= lsqerrors(B,F,c0,m,x,y,sx,varargin)

if ~isempty(sx)
   B= sx.*B;
end

if nargout==1
	res= feval(F.costFunc,B,m,x,y,varargin{:});
else
    % evaluate residuals and gradients
	[res,J]= feval(F.costFunc,B,m,x,y,varargin{:});
	J= J/c0;
    if ~isempty(sx)
        n=size(J,2);
        J= J*sparse(1:n,1:n,sx,n,n);
    end
end	

res = res/c0;

% deal with nonfinite residuals
ok= isfinite(res);
if ~all(ok)
	res(~ok)= get(F,'MaxError');
end
% deal with complex residuals
if ~isreal(res)
	ir= abs(imag(res))>1e-6;
	ok= ok & ir; 
	res(ir)= get(F,'MaxError');
	res= real(res);
end
drawnow



% Nonlinear Constraints
function [c,ceq,gc,geq]= i_nlconstraints(B,F,c0,m,x,y,sx,varargin)

if ~isempty(sx)
    % scale parameters
    B= sx.*B;
end
ceq=[];
geq=[];
if nargout>2
    [c,gc]=feval(F.Constraints.nlcon,B,m,x,y,varargin{:});
    if ~isempty(sx)
        gc= sparse(1:n,1:n,1./sx,n,n)*gc;
    end
else
    c=feval(F.Constraints.nlcon,B,m,x,y,varargin{:});
end    

