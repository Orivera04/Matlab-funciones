% Script p1_2_12.m; finds max gamma and max climb rate and corres.
% alpha and normalized V vs. T/mg, T/mg assumed << 1; 10/96, 3/20/02
%
% For max gamma:
alm=1/12; eta=1/2; T=[0:.05:.9]; N=length(T); c=180/pi; un=ones(1,N);
al=alm*un; ga=T-2*eta*al; V=un./sqrt(al), rc=V.*sin(ga), ga=c*ga, 
al=c*al
%
% For max climb rate:
al1=sqrt(T.*T/(4*eta^2)+3*alm^2*un)-T/(2*eta); 
ga1=T-eta*(al1+alm^2*un./al1); V1=un./sqrt(2*eta*al1), 
rc1=ga1./sqrt(al1), ga1=c*ga1, al1=c*al1 
%
% See soln. to Pb.1.2.11 for plots