function [f,y,s,be]=marslin(p)
% Subroutine for Pb. 3.3.17; TDP for orbit transfer with small
% change in radius; uses FSOLVE to find (al, de) in analytical
% optimal solution to satisfy terminal constraints; s=[r u v]';
%                                                 2/97, 8/24/02
%
al=p(1); de=p(2); tf=3.35; a=.1405; N=100; 
t=tf*[0:1/N:1]; un=ones(1,N+1);
be=pi*un+atan2(sin(t-al*un),2*cos(t-al*un)-2*cos(de*un));
U=[sin(be); cos(be)]'; A=[0 1 0; 1 0 2; 0 -1 0];
B=[0 a 0; 0 0 a]'; C=[0 1 0; 1 0 2]; D=zeros(2);
[y,s]=lsim(A,B,C,D,U,t); f=y(N+1,:);