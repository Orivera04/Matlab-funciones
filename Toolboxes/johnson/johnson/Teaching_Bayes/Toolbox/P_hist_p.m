function post=p_hist_p(mids,probs,data,num)
%
% P_HIST_P Posterior distribution for a proportion using a histogram prior.
%	POST=P_HIST_P(MIDS,PROBS,DATA,NUM) returns a vector POST of posterior 
%	probabilities, where MIDS is a vector of midpoints of equally spaced
%	intervals, PROBS is a vector of corresponding prior probabilities,
%	DATA is the number of successes and failures, and NUM is the size
%	of the simulation sample in the computational algorithm.

if nargin==3, num=1000; end
s=data(1); f=data(2); n=length(mids);

dx=diff(mids(1:2));

p=mids(rdisc(num,probs))+(rand(1,num)-.5)*dx;

like=s*log(p)+f*log(1-p);
newprobs=exp(like-max(like));
newprobs=newprobs/sum(newprobs);

post=zeros(1,n+1); 
for i=2:(n+1)
  post(i)=sum(newprobs.*(p<=(mids(i-1)+dx/2)));
end
post=diff(post);

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



