function [beta,var,lint]=cmp(data,mKx)
% CMP Computation of posterior mode and log integral using Laplace method.
%
%      [BETA,VAR,LINT]=cmp(DATA,MKX) returns the posterior mode BETA, associated
%      variance-covariance matrix VAR, and log integral LINT, where DATA =[y n x]
%      is the data matrix and MKX is the prior distribution matrix MKX = [m K x].

%-------------------------------------------------------------  
%  Jim Albert - May 15, 1998
%-------------------------------------------------------------

p=size(mKx,2);
m=mKx(:,1); K=mKx(:,2); x=mKx(:,3:p);

datan=[data;m K x]; 

[beta,var]=breg_mle(datan,'l');

lp=x*beta; p=exp(lp)./(1+exp(lp));

lprior=sum(K.*m.*log(p)+K.*(1-m).*log(1-p)-betaln(K.*m,K.*(1-m)));

lint=lprior+llogit(data,beta')+.5*log(det(var));

function val=llogit(data,beta)
% Binomial logistic loglikelihood

[npt,p]=size(beta);
y=data(:,1); n=data(:,2); x=data(:,3:(p+2));
lp=x*beta'; p=exp(lp)./(1+exp(lp));
yy=n.*y*ones(1,npt); nn=n*ones(1,npt);
val=sum(yy.*log(p)+(nn-yy).*log(1-p))';

