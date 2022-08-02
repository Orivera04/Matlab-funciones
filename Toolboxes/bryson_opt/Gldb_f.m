function [f,s]=gldb_f(p,s0)                            
% Subroutine for Ex. 9.3.2b; s=[V ga h x]';   9/18/02 
%
N=length(p)-1; al=p(1:N); tf=p(N+1); 
[t,s]=odeu('gldb_s',al,s0,tf);   
f=-s(4,N);		    