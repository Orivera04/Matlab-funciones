function [c,ceq]=marc_c(be,s0,tf)      
% Subroutine for Example 3.4.2;         3/94, 1/11/02 
%
[t,s]=odeu('marc',be,s0,tf); N=length(be); rf=s(1,N); 
uf=s(2,N); vf=s(3,N); ceq=[uf vf-1/sqrt(rf)]; c=[];