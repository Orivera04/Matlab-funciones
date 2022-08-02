function [p1,p2]=pp_exch(t,data,num)
%
% PP_EXCH Posterior distribution for two proportions using an exchangeable prior.
%	[P1,P2]=PP_EXCH(T,DATA,NUM) returns a vector P1 of simulated values of
%	the first proportion and a vector P2 of simulated values for the second
%	proportion, where T is the prior standard deviation of the logits, DATA
%	is a vector containing the successes and failures in the two samples, and
%	NUM is the simulation sample size.

s1=data(1); f1=data(2); s2=data(3); f2=data(4);

if nargin==2, num=1000; end

m=randn(num,1);		% simulate prior mean of the logits

t1=randn(num,1)*t+m;    % simulate 
t2=randn(num,1)*t+m;	% logits

like=s1*t1-(s1+f1)*log(1+exp(t1))+s2*t2-(s2+f2)*log(1+exp(t2));
like=exp(like-max(like));
prob=like/sum(like);

i=rdisc(num,prob);
t1_p=t1(i); t2_p=t2(i);
p1=exp(t1_p)./(1+exp(t1_p)); p2=exp(t2_p)./(1+exp(t2_p));

function rand_indices=rdisc(n,p)

% given vector of probabilities p
% rdiscrete(n,p) simulates n random
% indices

q=cumsum(p);
r=rand(1,n);
rand_indices=ones(1,n);
for i=1:length(q)
  rand_indices=rand_indices+(r>(q(i)*ones(1,n)));
end

     

  



