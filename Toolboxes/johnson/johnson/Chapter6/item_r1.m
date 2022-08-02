function [bv,th_m,th_s]=item_r1(y,s_b,m)

% item_r  -  fits a 1-parameter probit item response model of the form
%
%                         p_ij = phi(t_i - g_j)
%
%            where the g_j are iid N(0, s_b)
%
% command:   [bv,th_m,th_s]=item_r1(y,s_b,m)
%
% input:     y - binary data matrix where rows are subjects 
%                and columns are items
%            s_b - prior standard deviation
%            m - number of iterations (default is 500)
%
% output:    bv - matrix of simulated values of b_i
%                (each row is a simulated vector)
%            th_m, th_s - vectors of means and standard deviations of the t_j

if nargin==2, m=500; end               % default is 500 Gibbs cycles

s=size(y); n=s(1); k=s(2);

mu=0; var=1;              			      % hyperparameters of theta prior

phat=(sum(y)+.5)/(n+1);				      % initial estimates
b=-phiinv(phat)*sqrt(5);   			   %
th=zeros(n,1);            			      %

bv=zeros(m,k);		  			            %
th_m=zeros(1,n);	  			            %
th_s=zeros(1,n);          			      %

h=waitbar(0,'Simulation in progress');

for kk=1:m 					                         % MAIN ITERATION LOOP

	lp=th*ones(1,k)-ones(n,1)*b;                  %
	bb=phi(-lp)   ;                               %  simulate latent
	u=rand(n,k);                                  %  data z
	tt=(bb.*(1-y)+(1-bb).*y).*u+bb.*y;            %
	z=phiinv(tt)+lp;                              %

	pvar=1/(k+1/var);                             % simulate theta
	mn=sum((z+ones(n,1)*b)')';                    % assuming N(mu,var) prior
	pmean=(mn+mu/var)*pvar;                       %
	th=randn(n,1)*sqrt(pvar)+pmean;               %

   pvar=1/(n+1/s_b^2);									 % simulate b
   mn=sum(-z+th*ones(1,k));                      %
   pmean=mn*pvar;                                %
   b=randn(1,k).*sqrt(pvar)+pmean;               %

	bv(kk,:)=b;                                   %  store simulated values
	th_m=th_m+th';                                %
	th_s=th_s+th'.^2;                             %

   waitbar(kk/m)
end

close(h)

th_m=th_m/m;					                      %  compute mean and standard 
th_s=sqrt(th_s/m-th_m.^2);                       %  deviation of simulated theta values


function val=phi(x)
val=.5*(1+erf(x/sqrt(2)));

function val=phiinv(x)
val=sqrt(2)*erfinv(2*x-1);

