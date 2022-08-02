function [av,gv,th_m,th_s]=item_r(y,s_a,s_g,m)

% item_r  -  fits a 2-parameter probit item response model of the form
%
%                         p_ij = phi(a_i t_j - g_i)
%
%            where the a_i are iid N(0, s_a), the g_i are iid N(0, s_g)
%
% command:   [av,gv,th_m,th_s]=item_r(y,s_a,s_g,m)
%
% input:     y - binary data matrix where rows are subjects 
%                and columns are items
%            s_a, s_b - prior standard deviations
%            m - number of iterations (default is 500)
%
% output:    av - matrix of simulated values of a_i
%                (each row is a simulated vector)
%            gv - matrix of simulated values of g_i
%            th_m, th_s - vectors of means and standard deviations of the t_j

if nargin==3, m=500; end               % default is 500 Gibbs cycles

s=size(y); n=s(1); k=s(2);

mu=0; var=1;              			      % hyperparameters of theta prior

a=2*ones(1,k);            			      % 
phat=(sum(y)+.5)/(n+1);				      % initial estimates
g=-phiinv(phat)*sqrt(5);   			   %
th=zeros(n,1);            			      %

av=zeros(m,k);		  			            %
gv=av;			  			               % set up storage
th_m=zeros(1,n);	  			            %
th_s=zeros(1,n);          			      %

h=waitbar(0,'Simulation in progress');

for kk=1:m 					      % MAIN ITERATION LOOP

	lp=th*a-ones(n,1)*g;                          %
	bb=phi(-lp)   ;                               %  simulate latent
	u=rand(n,k);                                  %  data z
	tt=(bb.*(1-y)+(1-bb).*y).*u+bb.*y;            %
	z=phiinv(tt)+lp;                              %

	v=1/sum(a.^2);				      					 % 
	pvar=1/(1/v+1/var);                           % simulate theta
	mn=sum(((ones(n,1)*a).*(z+ones(n,1)*g))')';   % assuming N(mu,var) prior
	pmean=(mn+mu/var)*pvar;                       %
	th=randn(n,1)*sqrt(pvar)+pmean;               %

	x=[th -ones(n,1)];                            %
   pp=[1/s_a^2 0;0 1/s_g^2];		                %  prior precison matrix
	amat=chol(inv(x'*x+pp));                      %
	bz=(x'*x+pp)\(x'*z);                          %  simulate {alpha, gamma)
   beta=amat'*randn(2,k)+bz;		                %
   a=beta(1,:); g=beta(2,:);

	av(kk,:)=a;                                   %
	gv(kk,:)=g;                                   %  store simulated values
	th_m=th_m+th';                                %
	th_s=th_s+th'.^2;                             %

   waitbar(kk/m)

end

close(h)

th_m=th_m/m;					                      %  compute mean and standard 
th_s=sqrt(th_s/m-th_m.^2);                       %  deviation of simulated theta values


t='1';
for i=2:k
t=str2mat(t,num2str(i));
end
figure
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
