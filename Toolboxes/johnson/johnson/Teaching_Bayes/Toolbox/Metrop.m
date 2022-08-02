function [v_th,arate]=metrop(logpost,th_0,m,scale,par)
% METROP - simulates from a 1-parameter posterior using Metropolis algorithm
%	V_TH=METROP(LOGPOST,TH_0,M,SCALE,PAR) returns a vector V_TH of simulated
%	values from the posterior distribution, where LOGPOST is a function
%	containing the definition of the log posterior, TH_0 is the starting
%	value, M is the number of values to simulate, SCALE is the
%	value of the standard deviation used in the steps of the random walk 
%	Metropolis algorithm, and PAR is vector of parameter values.

if nargin<4, scale=1; end
if nargin<3, m=1000; end
v_th=zeros(m,1);
f0=feval(logpost,th_0,par);
arate=0;
for i=1:m
  th_1=th_0+randn*scale;
  f1=feval(logpost,th_1,par);
  u=rand<exp(f1-f0);
  th_0=th_1*(u==1)+th_0*(u==0);
  f0=f1*(u==1)+f0*(u==0);
  v_th(i)=th_0; arate=arate+u;
end
arate=arate/m;
