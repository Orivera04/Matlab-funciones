function [f,s]=marc_f(be,s0,tf)      
% Subroutine for Example 3.4.2;                    3/94, 9/15/02 
%
[t,s]=odeu('marc',be,s0,tf); N=length(be); rf=s(1,N); uf=s(2,N);
vf=s(3,N); f=-rf; 

