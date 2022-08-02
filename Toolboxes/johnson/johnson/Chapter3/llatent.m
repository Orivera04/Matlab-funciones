function [log_scores,sz]=llatent(Mb,data)

% LLATENT logistic scores plot for latent residuals in logistic
%   regression
%
% [LOG_SCORES,SZ]=llatent(MB,DATA) returns vector LOG_SCORES of logistic
%   scores and vector SZ of posterior means of ordered latent residuals,
%   where MB is matrix of simulated regression values and DATA is data
%   matrix of form [y n x].  A logistic probability plot is displayed of 
%   the posterior means.

%-------------------------------------------------------------  
%  Jim Albert - May 15, 1998
%-------------------------------------------------------------

p=size(data,2); N=size(data,1);
y=data(:,1); n=data(:,2); x=data(:,3:p);
m=size(Mb,1); sz=zeros(N,1);

log_scores=Fi_logit(((1:N)-1/3)/(N+1/3));

for i=1:m
   
   lp=x*Mb(i,:)';
   bb=F_logit(-lp);
   tt=(bb.*(1-y)+(1-bb).*y).*rand(N,1)+bb.*y;
   z=Fi_logit(tt)+lp;
   sz=sz+sort(z-lp);
   
end

sz=sz/m;


plot(log_scores,sort(sz),'o');hold on;plot([-4 4],[-4 4],':')
xlabel('Logistic scores'); ylabel('Mean latent residuals')
hold off

function val=F_logit(x)
val=exp(x)./(1+exp(x));

function val=Fi_logit(y);
val=log(y./(1-y));
