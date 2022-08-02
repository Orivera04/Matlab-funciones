function [xmin,fmin,m,ntype]=nelmed(...
              F,x0,dx,epsx,epsf,M,ifpr,varargin)
% [xmin,fmin,m,ntype]=nelmed(...
%             F,x0,dx,epsx,epsf,M,ifpr,varargin)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function performs multidimensional
% unconstrained function minimization using the
% direct search procedure developed by 
% J. A. Nelder and R. Mead. The method is 
% described in various books such as: 
% 'Nonlinear Optimization', by M. Avriel
% 
% F        - objective function of the form
%            F(x,p1,p2,...) where x is vector 
%            in n space and p1,p2,... are any
%            auxiliary parameters needed to
%            define F
% x0       - starting vector to initiate 
%            the search
% dx       - initial polyhedron side length
% epsx     - convergence tolerance on x
% epsf     - convergence tolerance on 
%            function values
% M        - function evaluation limit to
%            terminate search
% ifpr     - when this parameter equals one,
%            different stages in the search
%            are printed
% varargin - variable length list of parameters
%            which can be passed to function F
% xmin     - coordinates of the smallest 
%            function value
% fmin     - smallest function value found
% m        - total number of function 
%            evaluations made
% ntype    - a vector containing
%            [ninit,nrefl,nexpn,ncontr,nshrnk]
%            which tells the number of reflect-
%            ions, expansions, contractions,and
%            shrinkages performed
%
% User m functions called: objective function 
%                  named in the argument list

if isempty(ifpr), ifpr=0; end
if isempty(M), M=500; end;
if isempty(epsf), epsf=1e-5; end
if isempty(epsx), epsx=1e-5; end

% Initialize the simplex array
x0=x0(:); n=length(x0); N=n+1; f=zeros(1,N);
x=repmat(x0,1,N)+[zeros(n,1),dx*eye(n,n)];
for k=1:N
  f(k)=feval(F,x(:,k),varargin{:});
end

ninit=N; nrefl=0; nexpn=0; ncontr=0; 
nshrnk=0; m=N; 

Erx=realmax; Erf=realmax; 
alpha=1.0; % Reflection coefficient
beta= 0.5; % Contraction coefficient
gamma=2.0; % Expansion coefficient

% Top of the minimization loop

while Erx>epsx | Erf>epsf 

  [f,k]=sort(f); x=x(:,k);

  % Exit if maximum allowable number of
  %function values is exceeded
  if m>M, xmin=x(:,1); fmin=f(1); return; end

  % Generate the reflected point and 
  % function value
  c=sum(x(:,1:n),2)/n; xr=c+alpha*(c-x(:,N));
  fr=feval(F,xr,varargin{:}); m=m+1;
  nrefl=nrefl+1;
  if ifpr==1, fprintf(' :RFL \n'); end

  if fr<f(1) 
    % Expand and take best from expansion
    % or reflection
    xe=c+gamma*(xr-c); 
    fe=feval(F,xe,varargin{:});
    m=m+1; nexpn=nexpn+1; 
    if ifpr==1, fprintf(' :EXP \n'); end

    if fr<fe
      % The reflected point was best
      f(N)=fr; x(:,N)=xr; 
    else
      % The expanded point was best
      f(N)=fe; x(:,N)=xe; 
    end

  elseif fr<=f(n)  % In the middle zone
    f(N)=fr; x(:,N)=xr;

  else
    % Reflected point exceeds second the
    % highest value so either use contraction
    % or shrinkage
    if fr<f(N)
      xx=xr; ff=fr; 
    else
      xx=x(:,N); ff=f(N); 
    end

    xc=c+beta*(xx-c);
    fc=feval(F,xc,varargin{:});
    m=m+1; ncontr=ncontr+1;
    
    if fc<=ff
      % Accept the contracted value
      x(:,N)=xc; f(N)=fc;
      if ifpr==1, fprintf(' :CNT \n'); end

    else
      % Shrink the simplex toward 
      % the best point
      x=(x+repmat(x(:,1),1,N))/2;
      for j=2:N
        f(j)=feval(F,x(:,j),varargin{:});
      end
      m=m+n; nshrnk=nshrnk+n;
      if ifpr==1, fprintf(' :SHR \n'); end
    end
  end
  
  % Evaluate parameters to check convergence
  favg=sum(f)/N; Erf=sqrt(sum((f-favg).^2)/n);
  xcent=sum(x,2)/N; xdif=x-repmat(xcent,1,N);
  Erx=max(sqrt(sum(xdif.^2)));
    
end % Bottom of the optimization loop

xmin=x(:,1); fmin=f(1);
ntype=[ninit,nrefl,nexpn,ncontr,nshrnk]; 