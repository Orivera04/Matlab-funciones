function Mb=b_probg(data,m);

% B_PROBIT Produces a simulated sample from a probit regression model
%       using a Gibbs sampling/data augmentation algorithm.
%      (allows for grouped data)
%
% input data = [y n x] = [observed_proportions sample_sizes cov_matrix]
% simulates probit model (vague prior) using data augmentation
% output:
%  Mb -  matrix of simulated values of beta

%-------------------------------------------------------------  
%  Jim Albert - May 15, 1998
%-------------------------------------------------------------

[N,q1]=size(data);
q=q1-2; Y=data(:,1); X=data(:,3:q1);
n=data(:,2);

% 'MAXIMUM LIKELIHOOD:'
[b0,var,dr,drs,dev,h]=probit(data);  		   % STARTING VALUES
beta=b0;

y=[]; x=[];
for i=1:N
      s=round(n(i)*Y(i)); f=round(n(i)*(1-Y(i)));
      y=[y;ones(s,1);zeros(f,1)];
      x=[x;ones(n(i),1)*X(i,:)];
end

NN=sum(n);
Mb=zeros(m,q); 
aa=chol(inv(x'*x));

h=waitbar(0,'Simulation running ...');
for i=1:m
	lp=x*beta;					                     %
	bb=phi(-lp);				                   	% SIMULATE
	tt=(bb.*(1-y)+(1-bb).*y).*rand(NN,1)+bb.*y;	%    Z
	z=phiinv(tt)+lp;			                   	%
						
	mn=(x'*x)\(x'*z);			                  	% SIMULATE
	beta=aa'*randn(q,1)+mn;			            	%   BETA
	
	Mb(i,:)=beta'; 
	
   waitbar(i/m)
end
close(h)

function [beta,var,dr,drs,dev,h]=probit(data,b1)
%
% data matrix of form [y | x] - y is observed proportion 
% sample size vector n
%
s=size(data);
k=s(2);
y=data(:,1);
n=data(:,2);
x=data(:,3:k);
p=(n.*y+.5)./(n+1);
eta=phiinv(p);
der=pdfnorm(eta);

if nargin==1
  w=diag(n.*(der.^2)./p./(1-p));
  z=eta+(y-p)./der;
  b1=(x'*w*x)\(x'*w*z);
end
b0=zeros(size(b1));
%
% loop until convergence
%
it=0;
while it<=10
	b0=b1;
	eta=x*b0;
	p=phi(eta);
	der=pdfnorm(eta);
	z=eta+(y-p)./der;
   	w=diag(n.*(der.^2)./p./(1-p));
	b1=(x'*w*x)\(x'*w*z);
	it=it+1;
end
beta=b1;
var=inv(x'*w*x);

o1=fix(n.*y+.5); o2=fix(n.*(1-y)+.5);
f1=n.*p; f2=n.*(1-p);

i1=(o1==0); i2=(o2==0); i3=(o1>0)&(o2>0);
dr=zeros(size(o1));
o=o1(i3); f=f1(i3); N=n(i3);
dr(i3)=((o>f)-(f>o)).*sqrt(2*o.*log(o./f)+2*(N-o).*log((N-o)./(N-f)));
o=o1(i1); f=f1(i1); N=n(i1);
dr(i1)=-sqrt(2*N.*log(N./(N-f)));
o=o1(i2); f=f1(i2); N=n(i2);
dr(i2)=sqrt(2*N.*log(N./f));

w1=sqrt(n.*(der.^2)./p./(1-p));
h=diag(w1)*x*inv(x'*w*x)*x'*diag(w1);
drs=dr./sqrt(1-diag(h));
dev=sum(dr.^2);

function val=pdfnorm(x,mu,sigma)

if nargin==1, mu=0; sigma=1; end

val=1/sqrt(2*pi)./sigma.*exp(-.5./sigma.^2.*(x-mu).^2);

function val=phi(x)
val=.5*(1+erf(x/sqrt(2)));

function val=phiinv(x)
val=sqrt(2)*erfinv(2*x-1);
