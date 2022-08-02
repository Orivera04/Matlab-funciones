function [c,ceq,s]=airc_c(p,s0,Vc,lc)      
% Subroutine for p4_5_24a;  9/15/02 
%
N=length(p)-1; al=p(1:N); tf=p(N+1); 
[t,s]=odeu('mintalt',al,s0,tf);  
Vf=s(1,N); gaf=s(2,N); hf=s(3,N);
ceq=[Vf-420/Vc gaf hf-2000/lc];
c=[];