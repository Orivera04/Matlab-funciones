function post=p_disc(p,prior,data)
%
% P_DISC Posterior distribution for a proportion with discrete models.
%	POST = P_DISC(P,PRIOR,DATA) returns a vector of posterior probabilities.
%	P is the vector of values of the proportion, PRIOR is the corresponding
%	vector of prior probabilities and DATA is the vector of data (number of
%	successes and failures in set of independent bernoulli trials.

s=data(1); f=data(2);
p1=p+.5*(p==0)-.5*(p==1);

like=s*log(p1)+f*log(1-p1);
like=like.*(p>0).*(p<1)-999*((p==0)*(s>0)+(p==1).*(f>0));
like=exp(like-max(like));

product=like.*prior;
post=product/sum(product);



