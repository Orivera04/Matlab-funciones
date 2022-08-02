function varargout=cgstab(varargin)
%CGSTAB  BiConjugate Gradients Stabilized(ell) for multiple right hand-sides.
%  X = CGSTAB(A,B) attempts to solve the system of linear equations A*X = B
%  for X. The coefficient matrix A must be square and the right hand side
%  B must by N-by-P, where A is N-by-N.
%
%  CGSTAB will start iterating from an initial guess which by default is
%  an array of size N-by-P of all zeros. Iterates are produced until the
%  method either converges, fails, or has computed the maximum number of
%  iterations. Convergence is achieved when an iterate X has relative
%  residual NORM(B(:,I)-A*X(:,I))/NORM(B(:,I)) less than or equal to the
%  tolerance of the method for all I=1:P. The default tolerance is 1e-8.
%  The default maximum number of iterations is 300. No preconditioning is used.
%  CGSTAB uses BiCGstab(ell) with ell = 4 as default.
%
%  [X,HIST] = CGSTAB(A,B) returns also the convergence history
%  (the norms of the subsequential residuals).
%
%  ... = CGSTAB('Afun',B)
%  The first input argument is either a square matrix (which can be full or
%  sparse, symmetric or nonsymmetric, real or complex), or a string
%  containing the name of an M-file which applies a linear operator to a
%  given array of size SIZE(B). In the latter case, N = SIZE(B,1).
%
%  The remaining input arguments are optional and can be given in
%  practically any order:
%  ... = CGSTAB(...,X0,TR0,OPTIONS,M)
%  where
%
%      X0        An N-by-P array of doubles: the initial guess.
%      TR0       An N-by-1 array of doubles: the shadow residual.
%      OPTIONS   A structure containing additional parameters.
%      M         String(s) or arrays(s): the preconditioner.
%
%  If X0 is not specified then X0 = ZEROS(N,P).
%  If TR0 is not specified then TR0 = (B-A*X0)*RAND(P,1).
%  The OPTIONS structure specifies certain parameters in the algorithm.
%
%   Field name          Parameter                              Default
%
%   OPTIONS.Tol         Convergence tolerance:                 1e-8
%   OPTIONS.MaxIt       Maximum number of iterations.          300
%   OPTIONS.Disp        Shows size of intermediate residuals.  1
%   OPTIONS.ell         ell for BiCGstab(ell).                 4
%   OPTIONS.TypeAcc                                            0
%            specifies in what sense the systems
%            of equations are to be solved
%            0: each equation with a relative accuracy Tol:
%                NORM(A*X(:,I)-B(:,I))<Tol*norm(B(:,I)) all I
%            1: each equation with an accuracy of Tol:
%                NORM(A*X(:,I)-B(:,I))<Tol              all I
%            2: each equation in the space with a
%            relative accuracy Tol:
%                NORM(A*X*MU-B*MU)<Tol*NORM(B*MU)
%                                   for all MU of size P-by-1
%   OPTIONS.Simultane                                          'yes'
%   OPTIONS.TypePrecond                                        'left'
%            Specifies in what way the preconditioner is to
%            be applied. The precodnitioning will always
%            be explicit, but it can be left, right, central
%            (=two-sided if two matrices have been specified),
%            or via the Eisenstat trick (if A is matrix and
%            the preconditioner is a diagonal matrix).
%   OPTIONS.Omega                                              0.97
%            If A is a matrix (not a string),
%            and no preconditioner has been specified, but
%            a type of preconditioning has been specied
%            then d_RILU(Omega) will be used, that is
%            a preconditoner M of the form
%            M = (TRIL(A,-1)+D)*INV(D)*(TRIU(A,1)+D)
%            with D diagonal with a specific property:
%            if Omega==0, DIAG(A-M)=ZEROS(N,1)        (d_ILU)
%            if Omega==1, (A-M)*ONES(N,1)=ZEROS(N,1)  (d_MILU)
%            else mixure of these.
%
%  If M is not specified then M = I (no preconditioning).
%  A preconditioner can be specified in the argument list:
%   ... = CGSTAB(...,M,...)
%   ... = CGSTAB(...,L,U,...)
%   ... = CGSTAB(...,L,U,P,...)
%   ... = CGSTAB(...,'M',...)
%   ... = CGSTAB(...,'L','U'...)
%  as an N-by-N matrix M (then M is the preconditioner),
%  or as N-by-N matrices L and U (then  L*U is the preconditioner),
%  or as N-by-N matrices L, U, and P (then P\(L*U) is the preconditioner),
%  or as one or two strings containing the name of  M-files ('M', or
%  'L' and 'U') which apply a linear operator to a given N-by-P array.
%
%  CGSTAB (without input arguments) lists the options and the defaults.


%   Gerard Sleijpen.
%   Copyright (c) april 99


global n_operator
hist=[]; x=[];

if nargin==0, ShowOptions, return, end

[x,r,tr,n,p0,kmax,tol,L,opl,kappa,show,simul]=ReadOptions(varargin{1:nargin});
if nargout==0, return, end
if n<1, [varargout{1:nargout}]=output([],[]); return, end
if n<L, A=MV(eye(n)); [varargout{1:nargout}]=output(A\r,[]); return, end
if p0==0, [varargout{1:nargout}]=output(zeros(n,0),[]); return, end

str='%2d accurate solution%s at step %3d\n';
str1='\rmax(|r_%i|/|r_0|) = %0.1e;  ';
str2='\r    |r_%i|/|r_0|  = %0.1e;  ';

if show, b=r; end, t0=clock;

[r,x,x0]=PreProcess(r,x);
[r,x,d0,p]=rot(r,x,p0,tol,opl);

J=1:p; J0=1:p0;
if isempty(tr)
  tr=r(:,1); rt=rand(p,1); rt=rt/norm(rt); tr=r(:,J)*rt;
else
  tr=tr/norm(tr);
end

%%% Iteration loops
if simul %%%%  banded BiCGstab(ell)

  r=[r,zeros(n,p0*L)]; u=zeros(n,L+1); S=reshape(1:p0*(L+1),p0,L+1);
  sigma=1; omega=1; Q=eye(p0);

  j=1; k=0; hist=[ones(1,p0),0,0]; K=0; warning off

  while k<kmax
    sigma=-omega*sigma;

    for l=1:L
      [w,rho,tau]=HHolder(r(:,S(J,l))'*tr); v=w/tau; rho=rho';
      for i=1:l
        r(:,S(J,i))=r(:,S(J,i))-(r(:,S(J,i))*w)*v';
      end
      Q(:,J)=Q(:,J)-(Q(:,J)*w)*v';
      x(:,J)=x(:,J)-(x(:,J)*w)*v';

      beta=rho/sigma;
      I=1:l; jI=S(j,I);
      u(:,I)=r(:,jI)-beta*u(:,I);
      u(:,l+1)=PMV(u(:,l));

      sigma=tr'*u(:,l+1); alpha=rho/sigma;
      x(:,j) = x(:,j) +alpha*u(:,1);
      r(:,jI)= r(:,jI)-alpha*u(:,I+1);

      r(:,S(J,l+1))=PMV(r(:,S(J,l)));
    end

    [mx,q]=max(mynorm(r(:,J))); jI=S(J(q),:);
    [z,omega]=Gamma(r(:,jI)'*r(:,jI),kappa);
    u(:,1)=u(:,1)-u(:,I+1)*z;
    for q=1:p, i=J(q);
      x(:,i)=x(:,i)+r(:,S(i,I))  *z;
      r(:,i)=r(:,i)-r(:,S(i,I+1))*z;
    end

    k=k+1;

    nrm=mynorm(r(:,J0));
                             hist=[hist;nrm,n_operator,0];
                             if show, fprintf(str1,k,max(nrm)), end
    if min(nrm(J))<tol
      J=J(find(nrm(J)>=tol));
      p1=p-length(J); K=K+p1*k; st=' '; if p1>1, st='s'; end
      fprintf(str,p1,st,k),                 hist(end,end)=p1;
      p=p-p1; if p==0, break, end

      if 0
        L1=2; [gamma,I,J1]=Res(r,S(J,1:L1+1),tol);
        if ~isempty(I), I=J(I);
          fprintf(', plus %d extra',length(I))
          x(:,I)=x(:,I)-r(:,reshape(S(J,1:L1),1,L1*p))*gamma;
          r(:,I)=r(:,I)-r(:,reshape(S(J,2:L1+1),1,L1*p))*gamma;
        end, J=J(J1);
        p1=length(J); K=K+(p-p1)*k; p=p1;
        if p==0, break, end
      end

     j=J(1);
     end

     if p>1 & mod(k,1)==0
       [rr,s,v]=svd(r(:,J),0); r(:,J)=rr*s;
       x(:,J)=x(:,J)*v; Q(:,J)=Q(:,J)*v;
     end

  end

  x=PostProcess(x*(Q'*d0),x0); warning on
  if show r=r(:,J0)*Q'; end

else %%% standard BiCGstab(ell)

  hist=[]; K=0; t0=clock;

  for j=1:p,
    sigma=1; omega=1; k=0; nrm=1; hist0=[nrm,n_operator,0];
    rr=[r(:,j),zeros(n,L)]; u=zeros(n,L+1);

    while k<kmax & nrm>=tol
      sigma=-omega*sigma;

      for l=1:L
        rho=tr'*rr(:,l);

        beta=rho/sigma;
        I=1:l;
        u(:,I)=rr(:,I)-beta*u(:,I);
        u(:,l+1)=PMV(u(:,l));

        sigma=tr'*u(:,l+1); alpha=rho/sigma;
        x(:,j) = x(:,j) +alpha*u(:,1);
        rr(:,I)= rr(:,I)-alpha*u(:,I+1);

        rr(:,l+1)=PMV(rr(:,l));
      end

      R=rr'*rr;
      z=R(I+1,I+1)\R(I+1,1);  omega=z(L,1);
      u(:,1)=u(:,1)-u(:,I+1)*z;
      x(:,j)=x(:,j)+rr(:,I) *z;
      rr(:,1)=rr(:,1)-rr(:,I+1)*z;

      k=k+1;

      nrm=norm(rr(:,1));
                           hist0=[hist0;nrm,n_operator,0];
                           if show, fprintf(str2,k,nrm), end
      if nrm<tol
        fprintf(str,1,'',k)
        if j<p, tol=tol*sqrt(p+1-j)/sqrt(p-j); end
      end

    end
    hist=vec2mat(hist,hist0(:,1));
    r(:,j)=rr(:,1); K=K+k;
  end
  if p<p0, hist=vec2mat(zeros(1,p0-p)+tol,hist); end
  k=K;
  k1=size(hist,1)-1; K1=(0:k1)'/k1; hist(:,p+1)=K1*n_operator;
  x=PostProcess(x*d0,x0);
end

if show
  t0=etime(clock,t0); p=p0;
  fprintf('\n\n'),
  accuracy=[mynorm(r)',(mynorm(b-MV(x))./mynorm(b))']
  fprintf('\nAll sol. in %4i steps.   Average/sol: %4i',k, ceil(K/p))
  fprintf('\nAll sol. in %4i MVs.     Average/sol: %4i',...
                                       n_operator, ceil(n_operator/p))
  fprintf('\nAll sol. in %0.3g sec.     Average/sol: %0.3g\n\n',t0, t0/p)
  hist(1,p+2)=t0;

  K=hist(:,p+1)/p; plot(K,log10(hist(:,1)),plt(p,1))
  if p>1, hold on, plot(K,log10(hist(:,2:p)),plt(p,2)), end
  if simul, bb='banded'; else, bb=''; end
  title(sprintf('%s BiCGstab(%i)',bb,L))
  xlabel(sprintf('# MVs/%i',p))
  ylabel('log_{10} ||r||_2')
  drawnow, zoom on, hold off
end

[varargout{1:nargout}]=output(x,hist);

return
%------------------------------------------------------------------------
function [w,rho,tau]=HHolder(w)
% [v,rho,tau]=HHolder(w)
%   w is a k vector (k=size(w,1))
%   Computes Housholder transformation H, H=I-(1/tau)*v*v',
%   for which H*w=rho*I(:,1) with I=eye(k)

  rho=w'*w; tau=w(1,:);
  rho1=rho-tau'*tau; rho=-sqrt(rho)*sign(tau);
  tau=tau-rho; w(1,:)=tau;
  tau=(rho1+tau'*tau)/2;

return
%------------------------------------------------------------------------
function [z,omega]=Gamma(G,kappa)

  l=size(G,1)-1; I=2:l;

  Gamma=[-1,0;G(I,I)\G(I,[1,l+1]);0,-1];
  Ng=Gamma'*G*Gamma;
  cosine=abs(Ng(1,2))/sqrt(Ng(1,1)*Ng(2,2)); omega=Ng(1,2)/Ng(2,2);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%% Increase |omega| for enhancing the stability of the BiCG part     %%%
  %%%   Sleijpen & Van der Vorst, Numerical Algor., 10 (1995) 203--223  %%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  if cosine<kappa, omega=(kappa/cosine)*omega; end

  z=Gamma(2:l+1,1)-omega*Gamma(2:l+1,2);

return
%------------------------------------------------------------------------
function [gamma,I1,I2]=Res(r,S,tol)

  [p,m]=size(S); I=1:p; m=m*p; J=p+1:m; tol=tol*tol;
  S=reshape(S,1,m);
  G=r(:,S)'*r(:,S);
  gamma=G(J,J)\G(J,I);
  nrm=diag(G(I,I)-G(I,J)*gamma);
  I1=find(nrm<tol); I2=find(nrm>=tol);
  gamma=gamma(:,I1);


return
%------------------------------------------------------------------------
%  PREPROCESS initial guess, residual
%------------------------------------------------------------------------
function [r,x,d0,p]=rot(r,x,p,tol,opl)

  str='\n%2d accurate solution%s at step %3d';

  nrm=mynorm(r); d0=eye(p);
  if opl==0,
    d0=diag(nrm); r=r/d0; x=x/d0;
  end
  [r,s,v]=svd(r,0); d0=v'*d0; x=x*v';
  switch opl
    case {0,1}
      r=r*s; s=diag(s)';
    otherwise
      d0=s\d0; x=x/s; s=ones(1,p);
  end

  if min(s)<tol
    p0=p; p=sum(s>=tol); p1=p0-p; st=' '; if p1>1, st='s'; end
    fprintf(str,p1,st,0)
  end

return
%------------------------------------------------------------------------
function [r,x,x0]=PreProcess(r,x)

  global type_preconditioning

  x0=[];
  if ~isempty(x)
    r=r-MV(x);
    switch type_preconditioning   %% shift problem is case of
      case {2,3,4}, x0=x; x=[];   %% right, two-sided, Eisenstat
    end
  end

  if isempty(x), x=zeros(size(r)); end %% trivial initial guess

  switch type_preconditioning     %% precondition residual in case of
    case 1,     r=Solve(r);       %% left
    case {3,4}, r=Solve(r,'L');   %% two-sided, Eisenstat
  end

return
%------------------------------------------------------------------------
function SetMatricesEisenstat
  %% set matrices for Eisenstat

  global A_operator D_precond L_precond U_precond

  n=size(A_operator,1);

  D_precond=L_precond;
  L_precond=D_precond\tril(A_operator,-1) + speye(n);
  U_precond=D_precond\triu(A_operator, 1) + speye(n);
  D_precond=D_precond\spdiags(spdiags(A_operator,0),0,n,n);
  D_precond=D_precond-2*speye(n);

return
%------------------------------------------------------------------------
%  POSTPROCESS final approximation
%------------------------------------------------------------------------
function x=PostProcess(x,x0)

  global type_preconditioning

  switch type_preconditioning   %% unprecondition approximation in case of
    case 2,     x=Solve(x);     %% right
    case {3,4}, x=Solve(x,'U'); %% two-sided, Eisenstat
  end

  if ~isempty(x0), x=x0+x; end  %% undo shift if problem was shifted

return
%------------------------------------------------------------------------
%  ACTIONS OPERATORS
%------------------------------------------------------------------------
function y=PMV(y)
% preconditioned matrix-vector multiplication

  global n_operator type_preconditioning

  n_operator=n_operator+size(y,2);

  switch type_preconditioning
    case 0, y=MV(y);                 % no precondioner
    case 1, y=MV(y);                 % left
            y=Solve(y);
    case 2, y=Solve(y);              % right
            y=MV(y);
    case 3, y=Solve(y,'U');          % two-sided
            y=MV(y);
            y=Solve(y,'L');
    case 4, y=EisenstatOperation(y); % Eisenstat trick
  end

return
%------------------------------------------------------------------------
function y=Solve(y,flag)
% Action preconditioner

  global type_preconditioner L_precond U_precond P_precond

  if nargin==1
    switch type_preconditioner
      case 0,     y=feval(L_precond,y);
      case 1,     y=feval(L_precond,y,'preconditioner');
      case 2,     y=feval(L_precond,y);
                  y=feval(U_precond,y);
      case 3,     y=feval(L_precond,y,'preconditioner');
                  y=feval(U_precond,y);
      case {4,5}, y=feval(L_precond,y,'L');
                  y=feval(L_precond,y,'U');
      case 6,     y=L_precond\y;
      case 8,     y=U_precond\(L_precond\y);
      case 9,     y=U_precond\(L_precond\(P_precond*y));
    end
  elseif strmatch(flag,'U')
    switch type_preconditioner
      case {2,3},  y=feval(U_precond,y);
      case {4,5},  y=feval(L_precond,y,'U');
      case {8,10}, y=U_precond\y;
    end
  elseif strmatch(flag,'L')
    switch type_preconditioner
      case 2,     y=feval(L_precond,y);
      case 3,     y=feval(L_precond,y,'preconditioner');
      case {4,5}, y=feval(L_precond,y,'L');
      case 8,     y=L_precond\y;
      case 10,    y=L_precond\y;
                  SetMatricesEisenstat
                  y=L_precond\y;
    end
  end

return
%------------------------------------------------------------------------
function y=MV(y)
% Action matrix/operator A

  global A_operator

  if ischar(A_operator)
    y=feval(A_operator,y);
  else
    y=A_operator*y;
  end

return
%------------------------------------------------------------------------
function y=EisenstatOperation(y)

  global D_precond L_precond U_precond

  y1=U_precond\y;
  y=y+D_precond*y1;
  y=y1+L_precond\y;

return
%------------------------------------------------------------------------
%   CONSTRUCTION PRECONDITIONER
%------------------------------------------------------------------------
function D=d_rilu(omega,gamma)
% D for the preconditioner M=(L_A+D)*inv(D)*(D+U_A), where A=L_A+D_A+U_A
% with D such that
%      diag(M-A)=0      if omega=0:  ILU
%     (M-A)*ones(n,1)=0 if omega=1: MILU

  global A_operator L_precond U_precond

  t0=clock;

  n=size(A_operator,1); D=diag(diag(A_operator));
  if gamma, return, end

  L_precond=tril(A_operator,-1);  U_precond=triu(A_operator,1);

  if omega<inf
    fprintf('Constructing RILU(%g)',omega)
    x=U_precond*(omega*ones(n,1)); omega=1-omega;
    %[I0,J]=find(L_precond); [I,I1]=sort(I0); J=J(I1); nn=length(I);
    [I,J]=find(L_precond); nn=length(I);
    for k=1:nn
      i=I(k); j=J(k);
      D(i,i)=D(i,i)-L_precond(i,j)*(D(j,j)\(omega*U_precond(j,i)+x(j,1)));
    end
    fprintf('\r                       \r')
  end

  L_precond=L_precond/D+speye(n);
  U_precond=U_precond+D;

  % fprintf('\rConstruction RILU(%g) took %g sec.',1-omega,etime(clock,t0))

return
%------------------------------------------------------------------------
%        INPUT
%------------------------------------------------------------------------
function [x,r,tr,n,p,maxit,tol,ell,opl,kappa,show,simul]=ReadOptions(varargin)

global A_operator n_operator L_precond U_precond P_precond

A_operator=varargin{1}; n_operator=0;

if ischar(A_operator)
  n=-1;
  if exist(A_operator) ~=2
    msg=sprintf('  Can not find the M-file ''%s.m''  ',A_operator);
    errordlg(msg,'MATRIX'),n=-2; return
  end
else
  [n,n] = size(A_operator);
  if any(size(A_operator) ~= n)
    msg=sprintf('  The operator must be a square matrix or a string.  ');
    errordlg(msg,'MATRIX'),n=-3;  return
  end
end

L_precond = [];
U_precond = [];
P_precond = [];

%%% defaults
tol   = 1e-8;
ell   = 4;
maxit = 300;
opl   = 0;
kappa = 0.7;
show  = 1;
simul = 1;
omega = [];

r=[]; x=[]; tr=[]; options=[]; msg=[]; nr=0; p=0;
if n==0, return, end
for j = 2:nargin
  if isstruct(varargin{j})
    options = varargin{j};
  elseif ~ischar(varargin{j})
    [n0,n1]=size(varargin{j});
    if nr<n0
      if ~isempty(r), msg=sprintf('%ith input argument is unknown',jr); end
      r=varargin{j}; nr=n0; p=n1; jr=j;
    elseif nr==n0 & n1==1
      if ~isempty(x) & ~isempty(tr)
        msg=sprintf('%ith input argument is unknown',jx);
      elseif ~isempty(x)
        tr=varargin{j};
      elseif p==1
        x=varargin{j}; jx=j;
      end
    elseif nr==n0 & n1==p
      if ~isempty(x)
        if all(size(x)==[n0,1]), if p>1, tr=x; end, else
        msg=sprintf('%ith input argument is unknown',jx); end
      end
      x=varargin{j}; jx=j;
    elseif isempty(L_precond) & (n1==n0 | n1==2*n0)
      L_precond=varargin{j};
    elseif isempty(U_precond) & n1==n0
      U_precond=varargin{j};
    elseif isempty(P_precond) & n1==n0
      P_precond=varargin{j};
    else
      msg=sprintf('%ith input argument is unknown',j);
    end
  elseif isempty(L_precond)
      L_precond=varargin{j};
  elseif isempty(U_precond)
      U_precond=varargin{j};
  else
    msg=sprintf('%ith input argument is unknown',j);
  end
end
if ~isempty(msg), warndlg(msg,'INPUT'), end

[n0,p]=size(r); if p==0, return, end
if n<0
  ok=1; eval('v=feval(A_operator,zeros(n0,0));','ok=0;')
  if ~ok
    msg=sprintf(' right-hand side vector is %d dimensional ',n0);
    msg=[msg,sprintf('\n%s does not accept %d-vectors ',A_operator,n0)];
    errordlg(msg,'MATRIX'), return
  end
  n=n0;
elseif n~=n0
  msg=sprintf(' size of the right-hand side vector ');
  msg=[msg,sprintf('\n  does not match size of the matrix ')];
  errordlg(msg,'MATRIX'),n=-2; return
end
if ~min([n,p] ~= size(x)), x=[]; end

n=SetPrecond(n); if n<0, return, end

fopts = []; if ~isempty(options), fopts=fields(options); end
if strmatch('Tol',fopts),     tol = options.Tol;         end
if strmatch('TypeAcc',fopts), opl = options.TypeAcc;             end
if strmatch('MaxIt',fopts), maxit = abs(options.MaxIt);          end
if strmatch('ell',fopts),     ell = round(abs(options.ell));     end
if strmatch('Angle',fopts), kappa = boolean(options.Angle,[kappa,inf]);
                            kappa = max(min(kappa,1),0);        end
if strmatch('Disp',fopts),  show =  boolean(options.Disp,show);  end
if strmatch('Simultane',fopts),simul = boolean(options.Simultane,1); end
if strmatch('Omega',fopts)
  omega = options.Omega;
  if ischar(omega) | ~all(size(omega)==[1,1]); omega=[]; end,
end
if strmatch('TypePrecond',fopts),
  n=SetTypePrecond(options.TypePrecond,omega,n);
  if n<0, return, end
end

if show>0, ShowChoices(x,r,tr,n,p,maxit,tol,ell,opl,kappa,show,simul), end
tol=tol/sqrt(p);

return
%------------------------------------------------------------------------
function n=SetPrecond(n)
% finds out how the preconditioners are defined (type_preconditioner)
% and checks consistency of the definition
%
% If M is the preconditioner then P*M=L*U. Defaults: L=U=P=I.
%
% type_preconditioner
%       0:   L M-file, no U,     L ~= A
%       1:   L M-file, no U,     L == A
%       2:   L M-file, U M-file, L ~= A, U ~= A, L ~=U
%       3:   L M-file, U M-file, L == A, U ~= A,
%       4:   L M-file, U M-file, L ~= A,         L ==U
%       5:   L M-file, U M-file, L == A,         L ==U
%       6:   L matrix, no U
%       8:   L matrix, U matrix  no P
%       9:   L matrix, U matrix, P matrix
%      10:   if Eisenstat & L diag. matrix; set in SetTypePrecond.m

  global A_operator ...
         type_preconditioning type_preconditioner ...
         L_precond U_precond P_precond

  type_preconditioning=0;
  if isempty(L_precond), return, end
  type_preconditioning=1;

  if ~isempty(U_precond) & ischar(L_precond)~=ischar(U_precond)
     msg=sprintf('  L and U should both be strings or matrices');
     errordlg(msg,'PRECONDITIONER'), n=-1; return
  end
  if ~isempty(P_precond) & (ischar(P_precond) | ischar(L_precond))
      msg=sprintf('  P can be specified only if P, L and U are matrices');
      errordlg(msg,'PRECONDITIONER'), n=-1; return
  end
  tp=6*~ischar(L_precond)+2*~isempty(U_precond)+~isempty(P_precond);
  if n>0 & tp<6
    tp=tp+strcmp(L_precond,A_operator);
    if tp>1, tp=tp+2*strcmp(L_precond,U_precond); end
  end
  type_preconditioner=tp;

  % Check consistency definitions
  if tp<6
    ok=1;
    if exist(L_precond) ~=2
      msg=sprintf('  Can not find the M-file ''%s.m''  ',L_precond);
      errordlg(msg,'PRECONDITIONER'), n=-1; return
    end
    if mod(tp,2)==1
      eval('v=feval(A_operator,zeros(n,1),''preconditioner'');','ok=0;')
      if ~ok
         msg='Preconditioner and matrix use the same M-file';
         msg1=sprintf(' %s.   \n',L_precond);
         msg2='Therefore the preconditioner is called';
         msg3=sprintf(' as\n\n\tw=%s(v,''preconditioner'')\n\n',L_precond);
         msg4='Put this "switch" in the M-file.';
         msg=[msg,msg1,msg2,msg3,msg4];
      end
    end
    if tp>3 | ~ok
      ok1=1;
      eval('v=feval(L_precond,zeros(n,1),''L'');','ok1=0;')
      eval('v=feval(L_precond,zeros(n,1),''U'');','ok1=0;')
      if ~ok1
        if ok
          msg='L and U use the same M-file';
          msg1=sprintf(' %s.m   \n',L_precond);
          msg2='Therefore L and U are called';
          msg3=sprintf(' as\n\n\tw=%s(v,''L'')',L_precond);
          msg4=sprintf(' \n\tw=%s(v,''U'')\n\n',L_precond);
          msg5=sprintf('Check the dimensions and/or\n');
          msg6=sprintf('put this "switch" in %s.m.',L_precond);
          msg=[msg,msg1,msg2,msg3,msg4,msg5,msg6];
        end
        errordlg(msg,'PRECONDITIONER'), n=-1; return
      elseif ~ok
        tp=5; type_preconditioner=5; U_precond=L_precond; ok=1; msg=[];
      end
    end
    if tp==0 | tp==2
      eval('v=feval(L_precond,zeros(n,1));','ok=0')
      if ~ok
         msg=sprintf('''%s'' should produce %i-vectors',L_precond,n);
         errordlg(msg,'PRECONDITIONER'), n=-1; return
      end
    end
    if tp == 2 | tp==3
      if exist(U_precond) ~=2
        msg=sprintf('  Can not find the M-file ''%s.m''  ',U_precond);
        errordlg(msg,'PRECONDITIONER'), n=-1; return
      else
        eval('v=feval(U_precond,zeros(n,1));','ok=0')
        if ~ok
          msg=sprintf('''%s'' should produce %i-vectors',U_precond,n);
          errordlg(msg,'PRECONDITIONER'), n=-1; return
        end
      end
    end
  end

  if tp==8 & ~min([n,n]==size(L_precond) &  [n,n]==size(U_precond))
    msg=sprintf('Both L and U should be %iX%i.',n,n);
    errordlg(msg,'PRECONDITIONER'), n=-1; return
  end

  if tp==6
    if min([n,2*n]==size(L_precond))
      U_precond=L_precond(:,n+1:2*n); L_precond=L_precond(:,1:n);
      type_preconditioner=8;
    elseif min([n,3*n]==size(L_precond))
      U_precond=L_precond(:,n+1:2*n); P_precond=L_precond(:,2*n+1:3*n);
      L_precond=L_precond(:,1:n); type_preconditioner=9;
    elseif ~min([n,n]==size(L_precond))
      msg=sprintf('The preconditioning matrix\n');
      msg2=sprintf('should be %iX%i or %ix%i ([L,U]).\n',n,n,n,2*n);
      errordlg([msg,msg2],'PRECONDITIONER'), n=-1; return
    end
  end

return
%------------------------------------------------------------------------
function n=SetTypePrecond(tp,omega,n)
% finds out how the preconditioning is to be implemented (type_preconditioning)
% and checks consistency of the definition
%
% type_preconditioning
%             0:   no preconditioning
%             1:   explicit left
%             2:   explicit right
%             3:   explicit central (= twosided)
%             4:   explicit twosided with Eisenstat trick


  global A_operator ...
         type_preconditioning type_preconditioner ...
         L_precond U_precond A_omega

  type_preconditioning=strmatch(lower(tp(1:2)),['no';'le';'ri';'ce';'ei'])-1;

  A_omega=[];
  % Check consistency definitions
  if isempty(L_precond) & type_preconditioning>0;
    msg=sprintf('There is no preconditioner.');
    msg1=sprintf('\n\nDo you want to continue with');
    msg2=sprintf('\n   1) no preconditioner,\n   2) ');
    msg4=sprintf('stop?'); button='ri';
    if ~ischar(A_operator) & isempty(omega) % construct preconditioner from A
      msg3=sprintf('a preconditioner constructed from A, or  \n   3) ');
      button=questdlg([msg,msg1,msg2,msg3,msg4],'PRECONDITIONER',...
             'no precond.','precond.','stop','precond.');
    end
    if ischar(A_operator)
      button=questdlg([msg,msg1,msg2,msg4],'PRECONDITIONER',...
             'no precond.','stop','stop');
    end
    button=lower(button(1:2));
    if strcmp(button,'st'),  n=-1; return, end
    if strcmp(button,'no'), type_preconditioning=0; return, end
    if isempty(omega)
      msg=sprintf('\nPrecondition with');
      button=questdlg(msg,'PRECONDITIONER',...
          'Diag(A)','SOR','RILU(omega)','RILU(omega)');
      button=lower(button(1:2));
      omega=inf;
      if strcmp(button,'ri')
        helpdlg('Give omega (in Matlab window)','RILU(omega)')
        while omega==inf
          o=input('RILU(0)=ILU; RILU(1)=MILU.\nGive omega (default 0.97):');
          if isempty(o), o=0.97; end
          if ~ischar(o) & all(size(o)==1), omega=o; end
        end
      end
    end
    D=d_rilu(omega,strcmp(button,'di'));
    type_preconditioner=8; A_omega=omega;
    if type_preconditioning==4, L_precond=D; end
    if strcmp(button,'di'), L_precond=D; type_preconditioner=6; end
  end

  if max(type_preconditioner==[0;1;6]) & type_preconditioning==3;
    if max(type_preconditioner==[0;1])
    %% Check whether L_precond accepts 'L' and 'U'
       ok=1;
       eval('v=feval(L_precond,zeros(n,1),''L'');','ok=0;')
       eval('v=feval(L_precond,zeros(n,1),''U'');','ok=0;')
       if ok
         type_preconditioner=type_preconditioner+4;
       else
         msg=sprintf('There is no L_preconditioner and U_preocnditioner');
         msg1=sprintf('\nDo you want to conitue with left preconditioning?');
         button=questdlg([msg,msg1],'PRECONDITIONER','Yes','No','Yes');
         if strcmp(button,'No'),  n=-1; return, end
       end
    end
    type_preconditioning==1;
  end

  %% Check input for Eisenstat trick
  if type_preconditioning==4
    if ischar(A_operator)        % is A a matrix?
        msg=sprintf('Eisenstat trick requires a matrix %s',A_operator);
        n=-1; errordlg(msg,'PRECONDITIONER'), return
    end
    if type_preconditioner < 6   % is L a matrix?
        msg=sprintf('Eisenstat trick requires a diagonal matrix %s',L_precond);
        n=-1; errordlg(msg,'PRECONDITIONER'), return
    end
    if  norm(triu(L_precond,1),1)+norm(tril(L_precond,-1),1)~=0
                                 % is L diagonal?
        msg=sprintf('Eisenstat trick requires a diagonal matrix');
        n=-1; errordlg(msg,'PRECONDITIONER'), return
    end
    type_preconditioner = 10;
  end


return
%-------------------------------------------------------------------
function x = boolean(x,gamma,string)
%Y = BOOLEAN(X,GAMMA,STRING)
%  GAMMA(1) is the default.
%  If GAMMA is not specified, GAMMA = 0.
%  STRING is a matrix of accepted strings.
%  If STRING is not specified STRING = ['no ';'yes']
%  STRING(I,:) and GAMMA(I) are accepted expressions for X
%  If X=GAMMA(I) then Y=X. If X=STRING(I,:), then Y=GAMMA(I+1).
%  For other values of X, Y=GAMMA(1);

if nargin < 2, gamma=0; end
if nargin < 3, string=strvcat('no','yes'); gamma=[gamma,0,1]; end

if ischar(x)
  i=strmatch(lower(x),string,'exact');
  if isempty(i),i=1; else, i=i+1; end, x=gamma(i);
elseif max((gamma-x)==0)
elseif gamma(end) == inf
else, x=gamma(1);
end

return
%------------------------------------------------------------------------
%      OUTPUT
%------------------------------------------------------------------------
function varargout=output(x,hist)

  if nargout>0, varargout{1}=x; end
  if nargout>1, varargout{2}=hist; end

return
%------------------------------------------------------------------------
function ShowOptions

 fprintf('\n')
 fprintf('PROBLEM\n')
 fprintf('            A: [ square matrix | string ]\n');
 fprintf('            b: [ n=size(A,1) by p array of scalars ]\n\n');

 fprintf('OPTIONAL ARGUMENTS\n');
 fprintf('           x0: [ n by p array of scalars {zeros(n,p)} ]\n');
 fprintf('          tr0: [ n by 1 array of scalars {(b-A*x0)*rand(p,1)} ]\n');
 fprintf('      Precond: [ n by 2n matrix | string {identity} ]\n');
 fprintf('            L: [ n by  n matrix | string {identity} ]\n');
 fprintf('            U: [ n by  n matrix | string {identity} ]\n');
 fprintf('            P: [ n by  n matrix | string {identity} ]\n');
 fprintf('Parameterlist: [ struct {see below}]\n');
 fprintf('\n')

 fprintf('PARAMETERLIST\n');
 fprintf('          Tol: [ positive scalar {1e-8} ]\n');
 fprintf('         Disp: [ yes | {no} | 2 ]\n');
 fprintf('        MaxIt: [ positive integer {300} ]\n');
 fprintf('          ell: [ positive integer {4} ]\n');
 fprintf('      TypeAcc: [ {0} | 1 | 2 ]\n');
 fprintf('    Simultane: [ {yes} | no ]\n');
 fprintf('        Angle: [ double in [0,1] {0.7} ]\n');
 fprintf('  TypePrecond: [ no | {left} | right | central | Eisenstat trick ]\n');
 fprintf('        Omega: [ double {[]} ]\n');

 fprintf('\n')

return
%------------------------------------------------------------------------
function ShowChoices(x,r,tr,n,p,kmax,tol,L,opl,kappa,show,simul)

  global A_operator ...
         type_preconditioning type_preconditioner ...
         L_precond U_precond P_precond A_omega

  fprintf('\n\nBiCGstab(%i)\n==================\n',L)

  fprintf('\nPROBLEM\n')
  fprintf('             A: ')
  if ischar(A_operator)
    fprintf('''%s.m''\n',A_operator);
  elseif issparse(A_operator)
    fprintf('[%ix%i sparse]\n',n,n);
  else
    fprintf('[%ix%i double]\n',n,n);
  end
  fprintf('             b: [%ix%i double]\n',n,p);

  fprintf('\nOPTIONAL ARGUMENTS\n');
  fprintf('            x0: ')
  if norm(x)==0
    fprintf('zeros(%i,%i)\n',n,p);
  else
    fprintf('[%ix%i double]\n',n,p);
  end
  fprintf('           tr0: ');
  if isempty(tr)
    fprintf('(b-A*x0)');
    if p>1, fprintf('*rand(%i,1)',p); end, fprintf('\n');
  else
    fprintf('[%ix1 double]\n',n);
  end

  %% preconditioner
  if type_preconditioning
    if ~isempty(A_omega)
      if A_omega<inf
        fprintf('             D: d_RILU(%g)\n',A_omega);
      else
        fprintf('             D: Diag(A)\n');
      end
      if type_preconditioning < 4
        if ~isempty(U_precond)
          fprintf('     L_precond: (tril(A,-1)+D)/D\n',n,n);
          fprintf('     U_precond: triu(A,+1)+D\n',n,n);
        else
          fprintf('     L_precond: D\n',n,n);
        end
      end
    else
      switch type_preconditioner
        case {0,1},     fprintf('preconditioner: ''%s.m''\n',L_precond);
        case {2,3,4,5}, fprintf('     L_precond: ''%s.m''\n',L_precond);
                        fprintf('     U_precond: ''%s.m''\n',U_precond);
        case 6
          fprintf('preconditioner: ')
          if issparse(L_precond)
            fprintf('[%ix%i sparse]\n',n,n);
          else
            fprintf('[%ix%i double]\n',n,n);
          end
        case 8
          if issparse(L_precond)
            fprintf('     L_precond: [%ix%i sparse]\n',n,n);
            fprintf('     U_precond: [%ix%i sparse]\n',n,n);
          else
            fprintf('     L_precond: [%ix%i double]\n',n,n);
            fprintf('     U_precond: [%ix%i double]\n',n,n);
          end
        case 9
          if issparse(L_precond)
            fprintf('     L_precond: [%ix%i sparse]\n',n,n);
            fprintf('     U_precond: [%ix%i sparse]\n',n,n);
            fprintf('     P_precond: [%ix%i sparse]\n',n,n);
          else
            fprintf('     L_precond: [%ix%i double]\n',n,n);
            fprintf('     U_precond: [%ix%i double]\n',n,n);
            fprintf('     P_precond: [%ix%i double]\n',n,n);
          end
        case 10
          fprintf('     L_precond: [%ix%i diagonal]\n',n,n);
      end
    end
  end


  fprintf('\nPARAMETERS\n');
    fprintf('           Tol: %g\n',tol);
    fprintf('          Disp: %i\n',show);
    fprintf('         MaxIt: %i\n',kmax);
    fprintf('       TypeAcc: %i\n',opl);
    if p>1, fprintf('     Simultane: %i\n',simul); end
    fprintf('         Angle: %g\n',kappa);
    fprintf('   TypePrecond:');
    switch type_preconditioning
      case 0, fprintf(' no preconditioning\n');
      case 1, fprintf(' left preconditioning\n');
      case 2, fprintf(' right preconditioning\n');
      case 3, fprintf(' central preconditioning\n');
      case 4, fprintf(' Eisenstat trick\n');
    end
    fprintf('\n')

return
%------------------------------------------------------------------------
function typ=plt(p,gamma)

  kleur=['b';'r';'g';'k';'m'];
  plotsign=['-o';'-+';'-*';'-s';'-p';'-h';'-+'];
  plk=size(kleur,1); plk=mod(p-1,plk)+1;
  if nargin==1 | gamma==1
    pls=size(plotsign,1); pls=mod(p-1,pls)+1;
    typ=[kleur(plk,:),plotsign(pls,:)];
  end
  if gamma==2
    typ=[kleur(plk,:),'.:'];
  end

return
%------------------------------------------------------------------------
% AUXILLARY SUBROUTINES
%------------------------------------------------------------------------
function n=mynorm(r)

  n=(sqrt(sum(conj(r).*r)));

return
%------------------------------------------------------------------------
function tol=tolerance(tol,nrm,J)

p=length(nrm); I=setdiff(1:p,J); nrm=nrm(I);
tol=sqrt((tol^2-sum(nrm.*nrm))/length(J));

return
%------------------------------------------------------------------------
function x=vec2mat(x,y)

  [n,p]=size(x); [m,q]=size(y);
  if n==0, x=y; return, end
  if m==0, return, end
  if n<m
    x=[[x;ones(m-n,1)*x(n,:)],y]; return
  end
  if n>m
    x=[x,[y;ones(n-m,1)*y(m,:)]]; return
  end
  x=[x,y];

return
%-----------------------
