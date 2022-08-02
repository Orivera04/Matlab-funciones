function val=rbeta(alpha,beta,n)
% rbeta(alpha,beta,n) generates a vector of n Beta(alpha,beta) variates
a=rgam(n,alpha);
b=rgam(n,beta);
val=a./(a+b);

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
