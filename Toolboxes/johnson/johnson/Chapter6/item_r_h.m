function [av,gv,th_m,th_s,av_m,av_s2]=item_r_h(y,ab,m)

% item_r_h - fits a 2-parameter probit item response model of the form
%
%                         p_ij = phi(a_i t_j - g_i)
%
%            where the a_i are iid N(m, s)
%            m is flat, and variance s^2 is Inverse Gamma(a,b)
%
% command:   [av,gv,th_m,th_s,av_m,av_s2]=item_r_h(y,ab,m)
%
% input:     y - binary data matrix where rows are subjects and columns are items
%            ab - vector [a b] of hyperparameters of prior on variance s^2
%            m - number of iterations (default is 500)
%
% output:    av - matrix of simulated values of a_i - each row is a simulated vector
%            gv - matrix of simulated values of g_i
%            th_m, th_s - vectors of means and standard deviations of the t_j
%	     av_m - vector of simulated values of hyperparameter m
%            av_s2 - vector of simulated values of hyperparameter s^2

if nargin==2, m=500; end  % default is 500 Gibbs cycles

s=size(y); n=s(1); k=s(2);
pa=ab(1); pb=ab(2);

mu=0; var=1;              			      % hyperparameters of theta prior

a=2*ones(1,k);            			      % 
phat=(sum(y)+.5)/(n+1);            		      % initial estimates
g=-phiinv(phat)*sqrt(5);   			      %
th=zeros(n,1);            			      %
a_m=mean(a);
a_s2=1;

av=zeros(m,k);		  			      %
gv=av;			  			      % set up storage
th_m=zeros(1,n);	  			      %
th_s=zeros(1,n);          			      %
av_s2=zeros(m,1);				      %
av_m=zeros(m,1);				      %

h=waitbar(0,'Simulation in progress');

for kk=1:m 					      % MAIN ITERATION LOOP

	lp=th*a-ones(n,1)*g;                          %
	bb=phi(-lp);                                  %  simulate latent
	u=rand(n,k);                                  %  data z
	tt=(bb.*(1-y)+(1-bb).*y).*u+bb.*y;            %
	z=phiinv(tt)+lp;                                %
                                                                                                                                                                                                                           
	v=1/sum(a.^2);                                %
	pvar=1/(1/v+1/var);                           %  simulate theta
	mn=sum(((ones(n,1)*a).*(z+ones(n,1)*g))')';   %  assuming N(mu,var) prior
	pmean=(mn+mu/var)*pvar;                       %
	th=randn(n,1)*sqrt(pvar)+pmean;               %

	x=[th -ones(n,1)];                            %
        pp=[1/a_s2 0;0 0];			      %  prior precison matrix
  	pm=[a_m 0]';				      %  prior mean vector
	amat=chol(inv(x'*x+pp));                      %
	bz=(x'*x+pp)\(x'*z+pp*pm*ones(1,k));          %  simulate {alpha, gamma)
        beta=amat'*randn(2,k)+bz;		      %
        a=beta(1,:); g=beta(2,:);		      %

	a_m=mean(a)+randn*sqrt(a_s2/k);	      
	b1=pb+.5*sum((a-a_m).^2);
        a1=pa+k/2;
        a_s2=b1/rgam(1,a1);

	av(kk,:)=a;                                   %
	gv(kk,:)=g;                                   %  store simulated values
	th_m=th_m+th';                                %
	th_s=th_s+th'.^2;                             %
	av_s2(kk)=a_s2;
	av_m(kk)=a_m;
  	

   waitbar(kk/m);
   
end

close(h)

th_m=th_m/m;					      %  compute mean and standard 
th_s=sqrt(th_s.^2/m-th_m.^2);                         %  deviation of simulated theta values


t='1';
for i=2:k
t=str2mat(t,num2str(i));
end
clf
gm=mean(gv); am=mean(av);
gr=max(gm)-min(gm); ar=max(am)-min(am);
ax=[min(gm)-.1*gr max(gm)+.1*gr min(am)-.1*ar max(am)+.1*ar];
text(mean(gv),mean(av),t)
axis(ax)
xlabel('DIFFICULTY');ylabel('DISCRIMINATION')

function val=phi(x)
val=.5*(1+erf(x/sqrt(2)));

function val=phiinv(x)
val=sqrt(2)*erfinv(2*x-1);

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

