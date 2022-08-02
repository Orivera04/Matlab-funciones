function sp=gld_s(t,s,flag,p)
% Subroutine for GLD_F and GLD_C;                      9/17/02 
%
alm=1/12; eta=.5; V=s(1); ga=s(2); N=length(p)-1; al1=p(1:N)'; 
tf=p(N+1); t1=tf*[0:1/(N-1):1]'; al=interp1(t1,al1,t);
sp=[-eta*(al^2+alm^2)*V^2-sin(ga) al*V-cos(ga)/V ...
     V*sin(ga) V*cos(ga)]';
