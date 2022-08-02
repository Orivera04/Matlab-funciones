function [xf,termcode]=mmfsolve(varargin)
%MMFSOLVE Solve a Set of Nonlinear Equations. (MM)
% [Xf,TermCode]=MMFSOLVE(FUN,Xo,Options,P1,P2,...)
% finds a zero of the vector function FUN(X,P1,P2,...) starting from
% the initial guess Xo, passing optional parameters P1,P2,... to FUN.
% FUN is a function handle or a function M-file that evaluates FUN(X,...).
% Options is an optional structure that defines algorithm behavior.
% If Options is empty, i.e., [], default Options are used.
%
% Options=MMFSOLVE('Name',Value,...) sets values in Options structure
% based on the Name/Value pairs:
% Name        Values {default}   Description
% 'Display'   ['on' {'off'}]     Display iteration information
% 'Jacobian'  {'broyden'}        Broyden's Jacobian approximation
% 'Jacobian'   'finite'          Finite Difference Jacobian
% 'Jacobian'  'JNAME'            Analytic Jacobian in JNAME.M
% 'FunTol'     {1e-7}            NORM(FUN(X),1) stopping tolerance
% 'MaxIter'    {100}             Maximum number of iterations
% 'MaxStep'    value             Maximum step size in X allowed
% 'Scale'     ['on' {'off'}]     Scale algorithm using Xo
%
% Options=MMFSOLVE(Options,'Name','Value',...) updates the Options structure
% with new parameter values.
%
% Xf = final approximation
% TermCode = termination code:
%            1 = normal return, 2 = two steps too small
%            3 = line search failure, 4 = too many iterations
%            5 = five steps too big, 6 = stuck at minimizer

% Reference: Algorithm D6.1.3 in "Numerical Methods for Unconstrained
% Optimization and Nonlinear Equations," by Dennis and Schnabel,
% Siam's Classics in Applied Mathematics, no. 16, (2)nd printing 1996.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 5/6/97, 7/30/98, 2/25/01
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==1 & strcmp('default',varargin(1))  % set default parameters
   xf.Display='off'; xf.Jacobian='broyden'; xf.MaxIter=100;
   xf.MaxStep=0; xf.Scale='off'; xf.FunTol=1e-7;
   return
end
if isstruct(varargin{1}) % check if Options=MMFSOLVE(Options,'Name','Value',...)
   if ~isfield(varargin{1},'Jacobian')
      error('Options Structure not Correct for MMFSOLVE.')
   end
   xf=varargin{1};
   for i=2:2:nargin-1
      name=varargin{i};
      if ~ischar(name), error('Parameter Names Must be Strings.'), end
      name=lower(name(isletter(name)));
      value=varargin{i+1};
      if     strncmp(name,'d',1),    xf.Display=value;
      elseif strncmp(name,'f',1),    xf.FunTol=value(1);
      elseif strncmp(name,'j',1),    xf.Jacobian=value;
      elseif strncmp(name,'maxi',4), xf.MaxIter=value(1);
      elseif strncmp(name,'maxs',4), xf.MaxStep=value(1);
      elseif strncmp(name,'s',1),    xf.Scale=value;
      else, disp(['Unknown Parameter Name --> ' name])
      end
   end
   return
end
if ischar(varargin{1}) % check for Options=MMFSOLVE('Name','Value',...)
   Pnames=char('display','funtol','jacobian','maxiter','maxstep','scale');
   if ~isempty(strmatch(lower(varargin{1}),Pnames))
      xf=mmfsolve('default');  % get default values
      xf=mmfsolve(xf,varargin{:});
      return
   end
end
% MMFSOLVE('FUN',Xo,Options,P1,P2,...)

FUN=varargin{1};
if ~(isvarname(FUN) | isa(FUN,'function_handle'))
   error('FUN Must be a Function Handle or M-file Name.')
end
xc=varargin{2};
if nargin>2 & isstruct(varargin{3})
   options=varargin{3};
else         options=mmfsolve('default');
end
if nargin>3, P=varargin(4:nargin);
else         P={};
end

if ~isstruct(options) | ~isfield(options,'Jacobian')
   error('Options Structure not Correct for MMFSOLVE.')
end

% Steps 2 and 3
[options,errmsg]=local_neinck(FUN,xc,options,P{:});
xf=xc;
error(errmsg)

% Step 4
itncount=0;

% Step 5
[fc,FVc]=local_nefn(FUN,xc,options,P{:});

% Steps 6 and 7
consecmax=0;
if max(options.Sf.*abs(FVc))<=options.FunTol/100
   xf=xc;
   termcode=0;
   return
end
if options.analjac  % analytic Jacobian
   Jc=feval(options.Jacobian,xc,P{:});
else
   Jc=local_fdjac(FUN,xc,FVc,options,P{:});
end
gc=Jc'*(FVc.*(options.Sf.^2));

% Step 8
% been there, done that

% Step 9
restart=1;
termcode=0;

% Step 10
while termcode==0
   itncount=itncount+1;
   
   [M,Sn]=local_nemodel(FVc,Jc,gc,options);
   
   [retcode,xplus,fplus,FVplus,maxtaken]=...
      local_linesearch(FUN,xc,fc,gc,Sn,options,P{:});
   
   if retcode~=1 | restart
      if options.analjac
         Jc=feval(options.Jacobian,xc,P{:});
      elseif strcmp(options.Jacobian,'finite')
         Jc=local_fdjac(FUN,xc,FVplus,options,P{:});
      else
         Jc=local_broyunfac(Jc,xc,xplus,FVc,FVplus,options);
      end
      gc=Jc'*(FVplus.*(options.Sf.^2));
      
      [consecmax,termcode]=local_nestop(xc,xplus,FVplus,fplus,gc,...
         retcode,itncount,maxtaken,consecmax,termcode,options);
   end
   if retcode==1 |(termcode==2 & ~Restart & strcmp(options.Jacobian,'broy'))
      Jc=local_fdjac(FUN,xc,FVc,options,P{:});
      gc=Jc'*(FVc.*(options.Sf.^2));
      restart=1;
   else
      if termcode>0
         xf=xplus;
      else
         restart=0;
      end
      xc=xplus;
      fc=fplus;
      FVc=FVplus;
      if strcmp(options.Display,'on')
         fprintf(' Iteration = %.0f,  Current X:\n',itncount)
         disp(xc')
      end
   end
end
if strcmp(options.Display,'on')
   switch termcode
   case 1, disp('Successful Solution.')
   case 2, disp('2 Steps Too Small.')
   case 3, disp('Line Search Failure.')
   case 4, disp('Too Many Iterations.')
   case 5, disp('5 Steps Too Big.')
   case 6, disp('Stuck at Minimizer.')
   end
end


%---------------------------------------------------------------------------
function s=local_sign(x)

s=sign(x)+(x==0);


%---------------------------------------------------------------------------	
function [M,Sn]=local_nemodel(FVc,Jc,gc,options)

n=length(FVc);
M=diag(options.Sf)*Jc;
[M,M1,M2,sing]=local_qrdecomp(M);

if sing==0
   for j=2:n
      M(1:j-1,j)=M(1:j-1,j)/options.Sx(j);
   end
   M2=M2.*options.iSx;
   est=local_condest(M,M2);
else
   est=0;
end

if sing==1 | est>1./sqrt(eps)
   H=Jc'*diag(options.Sf);
   H=H*H';
   
   Hnorm=options.iSx(1)*abs(H(1,:))*options.iSx;
   for i=2:n
      Hper=abs(H(:,i))'*options.iSx + abs(H(i,:))*options.iSx;
      Hper=options.iSx(i)/Hper;
      Hnorm=max(Hnorm,Hper);
   end
   H=H+sqrt(n*eps)*Hnorm*(diag(options.Sx)^2);
   
   [M,maxadd]=local_choldecomp(H);
   Sn=-M'\(M\gc);
else
   for j=2:n
      M(1:j-1,j)=M(1:j-1,j)*options.Sx(j);
   end
   M2=M2.*options.Sx;
   Sn=-options.Sf.*FVc;
   Sn=local_qrsolve(M,M1,M2,Sn);
end


%---------------------------------------------------------------------------	
function [L,maxadd]=local_choldecomp(H)

minl=0;
maxoffl=sqrt(max(diag(H)));
minl2=sqrt(eps)*maxoffl;

maxadd=0;
n=size(H,1);
for j=1:n
   if j==1, L(j,j)=H(j,j);
   else,    L(j,j)=H(j,j)-L(j,1:j-1)*L(j,1:j-1)';
   end
   minljj=0;
   for i=j+1:n
      if (j==1), L(i,j)=H(j,i);
      else,      L(i,j)=H(j,i)-L(i,1:j-1)*L(j,1:j-1)';
      end
      minljj=max(abs(L(i,j)),minljj);
   end
   minljj=max(minljj/maxoffl,minl);
   if (L(j,j)>minljj^2),  % Normal Cholesky
      L(j,j)=sqrt(L(j,j));
   else,                  % Augment H(j,j)
      minljj=max(minl2,minljj);
      maxadd=max(maxadd,(minljj^2-L(j,j)));
      L(j,j)=minljj;
   end
   for i=j+1:n
      L(i,j)=L(i,j)/L(j,j);
   end
end


%---------------------------------------------------------------------------	
function est=local_condest(M,M2)

n=length(M2);
p=zeros(n,1);
pm=p;
x=p;

est=norm(triu(M)-diag(diag(M))+diag(M2),1);
x(1)=1/M2(1);
p(2:n)=M(1,2:n)*x(1);

for j=2:n
   xp=(+1-p(j))/M2(j);
   xm=(-1-p(j))/M2(j);
   temp=abs(xp);
   tempm=abs(xm);
   for i=j+1:n
      pm(i)=p(i)+M(j,i)*xm;
      tempm=tempm+abs(p(i))/abs(M2(i));
      p(i)=p(i)+M(j,i)*xp;
      temp=temp+abs(p(i))/abs(M2(i));
   end
   if temp>tempm, x(j)=xp;
   else,          x(j)=xm; p(j+1:n)=pm(j+1:n);
   end
end

est=est/norm(x,1);
x=local_rsolve(M,M2,x);

est=est*norm(x,1);


%---------------------------------------------------------------------------	
function [M,M1,M2,sing]=local_qrdecomp(M)

n=size(M,1);
M1=zeros(n,1);
M2=M1;
sing=0;

for k=1:n-1
   eta=max(M(k:n,k));
   if eta==0
      M1(k)=0;
      M2(k)=0;
      sing=1;
   else
      M(k:n,k)=M(k:n,k)/eta;
      sigma=local_sign(M(k,k))*norm(M(k:n,k));
      M(k,k)=M(k,k)+sigma;
      M1(k)=sigma*M(k,k);
      M2(k)=-eta*sigma;
      tau=(M(k:n,k)'*M(k:n,(k+1):n))/M1(k);
      M(k:n,(k+1):n)=M(k:n,(k+1):n)-M(k:n,k)*tau;
   end
end
M2(n)=M(n,n);


%---------------------------------------------------------------------------	
function b=local_qrsolve(M,M1,M2,b)

n=length(M2);
for j=1:n-1
   tau=(M(j:n,j)'*b(j:n))/M1(j);
   b(j:n)=b(j:n)-tau*M(j:n,j);
end
b=local_rsolve(M,M2,b);


%---------------------------------------------------------------------------	
function b=local_rsolve(M,M2,b)

n=length(M2);
b(n)=b(n)/M2(n);  % rsolve
for i=n-1:-1:1
   b(i)=(b(i)-M(i,i+1:n)*b((i+1):n))/M2(i);
end


%---------------------------------------------------------------------------	
function Jc=local_broyunfac(Jc,xc,xplus,FVc,FVplus,options)

s=xplus-xc;
Sx=options.Sx;
denom=norm(Sx.*s)^2;
tempi=FVplus-FVc-Jc*s;
i=find(abs(tempi)<options.eta*(abs(FVplus)+abs(FVc)));
tempi(i)=zeros(length(i),1);
Jc=Jc+tempi*(s.*(Sx.*Sx))'/denom;


%---------------------------------------------------------------------------	
function [consecmax,termcode]=local_nestop(xc,xplus,FVplus,fplus,gc,...
   retcode,itncount,maxtaken,consecmax,termcode,options)

termcode=0;
if retcode==1
   termcode=3;
elseif max(options.Sf.*abs(FVplus))<=options.FunTol
   termcode=1;
elseif max(abs(xplus-xc)./max(abs(xplus),options.iSx)) <= options.steptol
   termcode=2
elseif itncount>=options.MaxIter
   termcode=4
elseif maxtaken
   consecmax=consecmax+1;
   if consecmax==5, termcode=5; end
else
   consecmax=0;
   if ~strcmp(options.Jacobian,'broyden')
      if max(abs(gc).*max(abs(xplus),options.iSx)/max(fplus,length(xc)/2)) ...
            <= options.mintol
         termcode=6;
      end
   end
end

%---------------------------------------------------------------------------	
function [retcode,xplus,fplus,FVplus,maxtaken]=...
   local_linesearch(FUN,xc,fc,gc,p,options,varargin)

n=length(xc);
xplus=zeros(n,1);
fplus=0;
maxtaken=0;
retcode=2;
alpha=1e-4;

newtlen=norm(options.Sx .* p);
if newtlen>options.MaxStep
   p=p*options.MaxStep/newtlen;
   newtlen=options.MaxStep;
end

initslope=gc'*p;
rellength=max(abs(p)./max(abs(xc),options.iSx));
minlambda=options.steptol/rellength;
lambda=1;

while retcode>1
   
   xplus=xc+lambda*p;
   [fplus,FVplus]=local_nefn(FUN,xplus,options,varargin{:});
   if fplus<=fc+alpha*lambda*initslope
      retcode=0;
      maxtaken=(lambda==1)&(newtlen>0.99*options.MaxStep);
   elseif lambda<minlambda
      retcode=1;
      xplus=xc;
   else
      if lambda==1
         if strcmp(options.Display,'on')
            disp('Quadratic Line Search')
         end
         lambdatemp=-initslope/(2*(fplus-fc-initslope));
      else
         if strcmp(options.Display,'on')
            disp('Cubic Line Search')
         end
         ilp2=lambdaprev^(-2);
         il2=lambda^(-2);
         ab=1/(lambda-lambdaprev) * ...
            [il2 -ilp2;-lambdaprev*il2 lambda*ilp2]*...
            [fplus-fc-lambda*initslope;fplusprev-fc-lambdaprev*initslope];
         disc=ab(2)^2-3*ab(1)*initslope;
         if abs(ab(1))<=eps, lambdatemp=-initslope/(2*ab(2));
         else,               lambdatemp=(-ab(2)+sqrt(disc))/(3*ab(1));
         end
      end
      lambdatemp=min(lambdatemp,lambda/2);
      lambdaprev=lambda;
      fplusprev=fplus;
      lambda=max(lambda/10,lambdatemp);
   end
end

%---------------------------------------------------------------------------	
function Jc=local_fdjac(FUN,xc,Fc,options,varargin)

n=length(Fc);
sqrteta=sqrt(options.eta);
Jc=zeros(n);

for i=1:n
   Xc=xc;
   stepsize=sqrteta*max(abs(xc(i)),options.iSx(i))*local_sign(xc(i));
   Xc(i)=Xc(i)+stepsize;
   Fi=feval(FUN,Xc,varargin{:});
   Jc(:,i)=(Fi-Fc)/stepsize;
end


%---------------------------------------------------------------------------	
function [fplus,FVplus]=local_nefn(FUN,xc,options,varargin)

FVplus=feval(FUN,xc,varargin{:});
fplus=sum((options.Sf.*FVplus).^2)/2;


%---------------------------------------------------------------------------
function [options,errmsg]=local_neinck(FUN,xc,options,varargin)

n=size(xc,1);
f=feval(FUN,xc,varargin{:});
if strcmp(options.Scale,'off')
   options.Sx=ones(n,1);
   options.iSx=ones(n,1);
   options.Sf=ones(n,1);
else
   options.iSx=local_sign(xc);
   options.Sx=1./options.iSx;
   options.Sf=1./local_sign(abs(f));
end
if options.MaxStep==0 % find default maximum step
   options.MaxStep=1e3*max(norm(options.Sx.*xc),norm(diag(options.Sx)));
end
switch options.Jacobian
case {'broyden' 'finite'}
   options.analjac=logical(0);
otherwise
   options.analjac=logical(1);
   if ~ischar(options.Jacobian)
      error('Jacobian Must be M-file Name.')
   end
end
options.eta=eps;
options.steptol=eps^(2/3);
options.mintol=eps^(2/3);
errmsg='';
if size(xc,2)>1
   errmsg='Xo Must be a Column Vector.';
end
if n<2
   errmsg='Two or More Variables in X Required.';
end
if size(f,1)~=n
   errmsg='Xo and FUN(Xo) Must Return Equal Length Column Vectors.';
end
%---------------------------------------------------------------------------	
