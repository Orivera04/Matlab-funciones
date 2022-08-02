function [c,ceq]=gld_c(p,s0)                            
% Subroutine for Ex. 9.3.2a; s=[V ga h x]';  9/19/02 
%
alm=1/12; N=length(p)-1; al=p(1:N); tf=p(N+1);
optn=odeset('RelTol',1e-5);
[t,s]=ode23('gld_s',[0 tf],s0,optn,p); N1=length(t);
h1=s(:,3); ta=tf*[0:1/(N-1):1]'; h=interp1(t,h1,ta);
c=[-h' al-3*alm*ones(1,N)];        % h>=0, al<=3*alm
ceq=[s(N1,2) s(N1,3)];              % ga(tf)=h(tf)=0