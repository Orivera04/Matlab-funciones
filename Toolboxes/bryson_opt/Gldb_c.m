function [c,ceq]=gldb_c(p,s0)                            
% Subroutine for Ex. 9.3.2b; s=[V ga h x]';  9/18/02 
%
alm=1/12; N=length(p)-1; al=p(1:N); tf=p(N+1);
[t,s]=odeu('gldb_s',al,s0,tf); h=s(3,:); 
c=[-h al-3*alm*ones(1,N)];               % al<=3*alm
ceq=[s(2,N) s(3,N)];              % ga(tf)=h(tf)=0