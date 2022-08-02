function [av,gv,th_m,th_s,ath,aag]=l_itemr(y,sa,sg,m)

% item_r  -  fits a 2-parameter logistic item response model of the form
%
%                         p_ij = F(a_i t_j - g_i)
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

s=size(y); n=s(1); k=s(2);

mu=0; var=1;              			      % hyperparameters of theta prior

a=2*ones(1,k);            			      % 
phat=(sum(y)+.5)/(n+1);				      % initial estimates
g=-log(phat./(1+phat))*sqrt(5);   		%
th=zeros(n,1);            			      %

av=zeros(m,k);		  			            %
gv=av;			  			               % set up storage
th_m=zeros(n,1);	  			            %
th_s=zeros(n,1);          			      %
ath=zeros(n,1);
aag=zeros(1,k);

ca=.2; cg=.2; cth=1;

h=waitbar(0,'Simulation running ...');

for kk=1:m 					      % MAIN ITERATION LOOP

   l0=sum(llike(y,th,a,g)')'-.5/var*th.^2;       %
   th_p=th+randn(n,1)*cth;                       %
   l1=sum(llike(y,th_p,a,g)')'-.5/var*th_p.^2;   % Simulate theta_i
   prob=exp(l1-l0);                              %  
   accept=(rand(n,1)<prob);                      %
   th=th_p.*(accept==1)+th.*(accept==0);         %
   ath=ath+accept;
   
   l0=sum(llike(y,th,a,g))-.5*a.^2/sa^2-.5*g.^2/sg^2;        %
   a_p=a+randn(1,k)*ca; g_p=g+randn(1,k)*cg;                 %
   l1=sum(llike(y,th,a_p,g_p))-.5*a_p.^2/sa^2-.5*g_p.^2/sg^2;%  Simulate a_j,g_j
   prob=exp(l1-l0);                                          %
   accept=(rand(1,k)<prob);                                  %
   a=a_p.*(accept==1)+a.*(accept==0);                         %
   g=g_p.*(accept==1)+g.*(accept==0);                         %
   aag=aag+accept;

   av(kk,:)=a;                                   %
	gv(kk,:)=g;                                   %  store simulated values
	th_m=th_m+th;                                %
	th_s=th_s+th.^2;                             %

   waitbar(kk/m)
end

close(h);

th_m=th_m/m;					                      %  compute mean and standard 
th_s=sqrt(th_s/m-th_m.^2);                       %  deviation of simulated theta values
ath=ath/m;
aag=aag/m;

function val=llike(y,th,a,g)

n=size(y,1);
lp=th*a-ones(n,1)*g;                          
p=exp(lp)./(1+exp(lp));
val=y.*log(p)+(1-y).*log(1-p);
