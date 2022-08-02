function [Mb,accept]=breg_bay(data,m,link,prior,scale);

%B_LOGIT Produces a simulated sample from a logistic regression model
%        using the Metropolis algorithm.
%
%   [MB, ACCEPT]=breg_bay(DATA,M,LINK,SCALE) returns a matrix MB of simulated parameter 
%   values and ACCEPT, the acceptance proportion of the algorithm, where DATA 
%   is the data matrix (first column the observed proportions, second column the
%   sample sizes, and remaining columns the design matrix), M is the number of 
%   iterations of the algorithm, LINK is the link function ('l' for logit, 'p' for
%   for probit, and 'c' for complementary log-log), PRIOR is the conditional means
%   prior (first column m, second column K, and third column x), and SCALE is the 
%   scale factor used in the Metropolis-Hastings algorithm.

%-------------------------------------------------------------  
%  Jim Albert - May 15, 1998
%-------------------------------------------------------------


if nargin<5, scale=1; end
if nargin<4, prior=[]; end
if nargin<3, link='l'; end

[beta,var]=breg_mle(data,link);  % Finds maximum likelihood fit -- use as starting value

a=chol(var);                   % Takes cholesky decomposition

b=beta; p=length(beta);
Mb=zeros(m,p);                 % Sets up storage
lb=bl_post(data,b',link,prior);      % Evaluates log likelihood at current value

if nargin<3
  scale=1;                     % Sets scaling factor of metropolis algorithm equal to 1
end

h=waitbar(0,'Simulation in progress');
accept=0;

for i=1:m
   
  bc=b+scale*a'*randn(p,1);    % Candidate value selected
  lbc=bl_post(data,bc',link,prior);  % Evaluates log likelihood at candidate value
  prob=exp(lbc-lb);            % Computes acceptance probability
  if rand<prob                 % If random uniform is smaller than probability, accept
    lb=lbc; b=bc; accept=accept+1; % candidate value
  end
 
  Mb(i,:)=b';                  % Store simulated value
 
  if i/20==fix(i/20)           % Shows wait bar
    waitbar(i/m)
  end

end

accept=accept/m;               % Computes acceptance proportion
close(h)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [beta,var,fp,dev_df,pr,dr,adr]=breg_mle(data,link)

% MLE Finds maximum likelihood estimates for a binary regression model
%
%  [BETA,VAR,FP,DEV_DF,PR,DR,ADR]=mle(DATA,LINK) returns mle BETA, variance-
%  covariance matrix VAR, fitted probabilities FP, deviance and degrees of
%  freedom DEV_DF, Pearson residuals PR, deviance residuals DR, adjusted deviance
%  residuals ADR, where DATA is data matrix [y n x], and LINK is the link function
%  'l' (logit), 'p', (probit), or 'c' (complementary log-log).

s=size(data); k=s(2);
y=data(:,1); n=data(:,2); x=data(:,3:k);

p=(n.*y+.5)./(n+1);
eta=gi(p,link); de=d(eta,link);
w=diag(n.*de.^2./p./(1-p));
z=eta+(y-p)./de;
b1=(x'*w*x)\(x'*w*z);
b0=zeros(size(b1));
%
% loop until convergence
%
it=0;
while (it<=10)*(norm(b1-b0)>.001*norm(b0))
	b0=b1;
	eta=x*b0;
   p=g(eta,link); de=d(eta,link); 
   w=diag(n.*de.^2./p./(1-p));
   z=eta+(y-p)./de;
   b1=(x'*w*x)\(x'*w*z);
	it=it+1;
end
beta=b1;
var=inv(x'*w*x);

eta=x*beta;
fp=g(eta,link);

pr=n.*(y-fp)./sqrt(n.*fp.*(1-fp));

o1=fix(n.*y+.5); o2=fix(n.*(1-y)+.5);
f1=n.*fp; f2=n.*(1-fp);

i1=(o1==0); i2=(o2==0); i3=(o1>0)&(o2>0);
dr=zeros(size(o1));
o=o1(i3); f=f1(i3); N=n(i3);
dr(i3)=((o>f)-(f>o)).*sqrt(2*o.*log(o./f)+2*(N-o).*log((N-o)./(N-f)));
o=o1(i1); f=f1(i1); N=n(i1);
dr(i1)=-sqrt(2*N.*log(N./(N-f)));
o=o1(i2); f=f1(i2); N=n(i2);
dr(i2)=sqrt(2*N.*log(N./f));

adr=dr+(1-2*fp)./(6*sqrt(n.*fp.*(1-fp)));

dev=sum(dr.^2); df=s(1)-length(beta);
dev_df=[dev df];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function eta=gi(p,link)

if link=='l'
   eta=log(p./(1-p));
elseif link=='p'
   eta=phiinv(p);
elseif link=='c'
   eta=log(-log(1-p));
end

function p=g(eta,link)

if link=='l'
   p=exp(eta)./(1+exp(eta));
elseif link=='p'
   p=phi(eta);
elseif link=='c'
   p=1-exp(-exp(eta));
end

function val=d(eta,link)

if link=='l'
   p=exp(eta)./(1+exp(eta));
   val=p.*(1-p);
elseif link=='p'
   val=pdfnorm(eta);
elseif link=='c'
   val=exp(eta-exp(eta));
end

function val=pdfnorm(x,mu,sigma)

if nargin==1, mu=0; sigma=1; end

val=1/sqrt(2*pi)./sigma.*exp(-.5./sigma.^2.*(x-mu).^2);

function val=phi(x)
val=.5*(1+erf(x/sqrt(2)));

function val=phiinv(x)
val=sqrt(2)*erfinv(2*x-1);

function val=bl_post(data,beta,link,prior)
% Binomial regression loglikelihood

[npt,p]=size(beta);
y=data(:,1); x=data(:,3:(p+2)); n=data(:,2);
lp=x*beta';

if length(prior)>0
   m=prior(:,1); K=prior(:,2); xp=prior(:,3:(p+2));
   lp1=xp*beta';
end

if link=='l'
   p=exp(lp)./(1+exp(lp));
elseif link=='p'
   p=phi(lp);
elseif link=='c'
   p=1-exp(-exp(lp));
end

if length(prior)>0
if link=='l'
   pl=exp(lp1)./(1+exp(lp1)); lf1=lp1-2*log(1+exp(lp1));
elseif link=='p'
   pl=phi(lp); lf1=-.5*lp1.^2;
elseif link=='c'
   pl=1-exp(-exp(lp)); lf1=lp1-exp(lp1);
end
end

if (min(p)==0) | (max(p)==1)
   val=-1e20;
else
   val=sum(n.*y.*log(p)+n.*(1-y).*log(1-p));
end

if length(prior)>0
   if (min(pl)==0) | (max(pl)==1)
      val=-1e20;
   else
      val=val+sum((K.*m-1).*log(pl)+(K.*(1-m)-1).*log(1-pl)+lf1);
   end
end


