function v_th=gibbs(logpost,th_0,m,scale,par)
% GIBBS- simulates from a posterior using Gibbs sampling
%	V_TH=GIBBS(LOGPOST,TH_0,M,SCALE,PAR) returns a matrix V_TH of simulated
%	values from the posterior distribution, where LOGPOST is a function
%	containing the definition of the log posterior, TH_0 is a vector
%	containing the starting value, M is the number of values to simulate, 
%	SCALE is the vector of standard deviations used in the steps
%	in the random walk Metropolis algorithm, and PAR is the vector of
%	parameter values used in the function.

p=length(th_0);
if nargin<4, scale=1*ones(1,p); end
if nargin<3, m=1000; end
v_th=zeros(m,p);
f0=feval(logpost,th_0,par);
th_1=th_0;
for i=1:m
  for j=1:p
    th_1(j)=th_0(j)+randn*scale(j);
    f1=feval(logpost,th_1,par);
    u=rand<exp(f1-f0);
    th_0=th_1*(u==1)+th_0*(u==0);
    f0=f1*(u==1)+f0*(u==0);
    v_th(i,j)=th_0(j);
  end
end
  
