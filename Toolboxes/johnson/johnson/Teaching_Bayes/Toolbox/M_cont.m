function [m_sim,s_sim]=m_cont(data,num)
%
% M_CONT Simulated sample from the posterior for normal data, vague prior.
%	[M_SIM,S_SIM]=M_CONT(DATA,NUM) returns a vector M_SIM of simulated values 
%	from the marginal posterior density of the mean M and a vector S_SIM
%	of simulated values from the marginal posterior density of the 
%	standard deviation S, where DATA is the vector of data and NUM is the
%	size of the simulated sample.
% NOTE: uses function chi2rnd from Statistics Toolbox

if nargin==1,num=1000;end

n=length(data);
xbar=mean(data);
s=std(data);
s_sim=sqrt((n-1)*s^2./ch2rnd(n-1,num));
m_sim=xbar+randn(num,1).*s_sim/sqrt(n);

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

