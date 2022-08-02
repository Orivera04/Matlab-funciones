function sp=mart_s(t,s,flag,p)      
% Subroutine for MART_C of e04_5_2;             3/94, 9/17/02 
%                                       
T=.1405; mdot=.07489; a=T/(1-mdot*t); r=s(1); u=s(2); v=s(3); 
N=length(p); be1=p(1:N-1)'; tf=p(N); tp=tf*[0:1/(N-2):1]'; 
be=interp1(tp,be1,t); co=cos(be); si=sin(be); 
sp=[u  v^2/r-1/r^2+a*si  -u*v/r+a*co]';

