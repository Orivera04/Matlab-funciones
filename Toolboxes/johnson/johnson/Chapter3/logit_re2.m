function [Mbeta,Ms2,stds,sample]=logit_re2(ynx,m)

% fit of random effects model for conduct example of Chapter 3

%-------------------------------------------------------------  
%  Jim Albert - May 15, 1998
%-------------------------------------------------------------

p2=size(ynx,2); k=size(ynx,1); p=p2-2;
y=ynx(:,1); n=ynx(:,2); x=ynx(:,3:p2);

[beta,var]=breg_mle(ynx,'l'); aa=chol(var);

B=zeros(k,1); s2=1; mu=0; 
a=5; b=1.5; 
c=2*ones(k,1);

Mbeta=zeros(m,p); Ms2=zeros(m,1); 
sample=zeros(k,5);
stds=zeros(m,1);
h=waitbar(0,'Simulation in progress');

for i=1:m
   
   lp=x*beta+B; pr=exp(lp)./(1+exp(lp));
   l0=sum(n.*y.*log(pr)+n.*(1-y).*log(1-pr));
   betap=beta+aa'*randn(p,1);
   lp=x*betap+B; pr=exp(lp)./(1+exp(lp));
   l1=sum(n.*y.*log(pr)+n.*(1-y).*log(1-pr));
   prob=exp(l1-l0);
   if rand<prob, beta=betap; end
   
   lp=x*beta+B; pr=exp(lp)./(1+exp(lp));
   l0=n.*y.*log(pr)+n.*(1-y).*log(1-pr)-(B-mu).^2/2/s2;
   Bp=B+randn(k,1).*c;
   lp=x*beta+Bp; pr=exp(lp)./(1+exp(lp));
   l1=n.*y.*log(pr)+n.*(1-y).*log(1-pr)-(Bp-mu).^2/2/s2;
   probs=exp(l1-l0);
   accept=rand(k,1)<probs;
   B(accept)=Bp(accept);
   
   para=k/2+a; parb=sum((B-mu).^2)/2+b;
   s2=parb/rgam(1,para);
   
   mu=mean(B)+randn*sqrt(s2/k);
   
   lp=x*beta+B;
   pr=exp(lp)./(1+exp(lp));
   sy=sum((rand(k,4)<(pr*ones(1,4)))')';

   stds(i)=std(sy);
   for j=0:4
		sample(:,j+1)=sample(:,j+1)+(sy==j);
   end
 
   Mbeta(i,:)=beta'; Ms2(i)=s2;
   
    if i/20==fix(i/20)           % Shows wait bar
      figure(1)
      waitbar(i/m)
    end
  
end
close(h)
sample=sample/m;

function rn=rgam(n,alpha)
%  generates a vector of n gamma(alpha) variates
a=alpha-1;
rn=zeros(n,1);
while prod(rn)==0
   v1=-log(rand(n,1));
   v2=-log(rand(n,1));
	  id=v2>=(a*(v1-log(v1)-1));
			rn=rn+v1.*id.*(rn==0);	
end
rn=rn*alpha;
