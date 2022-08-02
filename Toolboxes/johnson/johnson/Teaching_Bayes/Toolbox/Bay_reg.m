function [beta,s]=bay_reg(y,X,num)
%
% BAY_REG Simulated sample from the posterior for a normal regression model.
%	[BETA,S]=BAY_REG(Y,X,NUM) returns a matrix BETA of simulated values
%	from the posterior distribution of the regression parameter and a
%	vector S of simulated values from the posterior of the residual
%	standard deviation, where Y is a column of the observed responses,
%	X is the design matrix, and NUM is the size of the simulated sample.

if nargin==2, num=1000; end
[n,k]=size(X);

% find least-squares estimates, variance matrix, and estimate of residual variance

RI=inv(X'*X);
b = X\y;
s2=1/(n-k)*(y-X*b)'*(y-X*b);

% simulate residual standard deviation

s=sqrt((n-k)*s2./ch2rnd(n-k,num));

% simulate regression vector

a=chol(RI);
beta=randn(num,k)*a.*(s*ones(1,k))+ones(num,1)*b';



function rn=ch2rnd(alpha,n)
%  rn=chi2rnd(alpha,n)generates a vector
%  of n chi2(alpha) variates

if nargin==1, n=1; end

rn=2*rgam(n,alpha/2);

function rn=rgam(n,alpha)
%  rn=rgam(n,alpha)generates a vector
%  of n gamma(alpha) variates
a=alpha-1;
rn=zeros(n,1);
while prod(rn)==0
   v1=-log(rand(n,1));
   v2=-log(rand(n,1));
	  id=v2>=(a*(v1-log(v1)-1));
			rn=rn+v1.*id.*(rn==0);	
end
rn=rn*alpha;

