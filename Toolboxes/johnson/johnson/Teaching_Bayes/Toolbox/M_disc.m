function post=m_disc(m,prior,data)
%
% M_DISC Posterior distribution for a normal mean with discrete models.
%	POST = M_DISC(P,PRIOR,DATA) returns a vector of posterior probabilities.
%	M is the vector of values of the mean, PRIOR is the corresponding
%	vector of prior probabilities and DATA is the vector of data 
%	(sample mean, sample size, and population standard deviation).

xbar=data(1); n=data(2); sigma=data(3);

like=-.5*n/sigma^2*(m-xbar).^2;
like=exp(like-max(like));

product=like.*prior;
post=product/sum(product);



