function [post,diff_dist]=pp_disc(p1,p2,prior,data)
%
% PP_DISC Posterior distribution for two proportions using discrete models.
%	[POST,DIFF_DIST]=PP_DISC(P1,P2,PRIOR,DATA) returns a matrix of
%	posterior probabilities POST and a probability distribution matrix
%	for the difference in proportions DIFF_DIST.  The vectors P1 and
%	P2 are vectors of values of the two proportions, PRIOR is the prior
%	probability matrix and DATA is the vector of successes and failures
%	for the two binomial samples.

[p1,p2]=meshgrid(p1,p2); p1=p1'; p2=p2';
s1=data(1); f1=data(2); s2=data(3); f2=data(4);

p1a=p1+.5*(p1==0)-.5*(p1==1);
p2a=p2+.5*(p2==0)-.5*(p2==1);

like1=s1*log(p1a)+f1*log(1-p1a);
int=(p1>0).*(p1<1);
like1=like1.*int-999*((p1==0)*(s1>0)+(p1==1).*(f1>0));

like2=s2*log(p2a)+f2*log(1-p2a);
int=(p2>0).*(p2<1);
like2=like2.*int-999*((p2==0)*(s2>0)+(p2==1).*(f2>0));

like=exp(like1+like2-max(max(like1+like2)));

post=prior.*like./sum(sum(prior.*like));

d=p2-p1; d=d(:); dpost=post(:);
[d,i]=sort(d); dpost=dpost(i);

diff=d(1); diff_post=dpost(1); j=1; i=1;
for i=2:length(d)
  if abs(d(i)-d(i-1))<1e-8
     diff_post(j)=diff_post(j)+dpost(i);
  else
     j=j+1;
     diff_post(j)=dpost(i); diff(j)=d(i);
  end
end
diff_dist=[diff' diff_post'];


     

  



