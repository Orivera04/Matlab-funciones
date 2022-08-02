% Script p9_3_13a.m; min time erection inverted pendulum using FMINCON
% with unconstrained u(t) and J=tf+mu*int(||u(t)|-umax|dt w/o gradient;
% s=[th q x v]'; 	                                      4/98, 3/29/02 
%
N=40; un=ones(1,N+1);    
%u0=[1 1 1 1 1 -1 -1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 1 1 1 ...
%    1 1 1 1 1 1 1 1 1 1 1 -1 -1 -1 -1 -1 -1]; tf=5; p0=[u0 tf];
load ipe_fg p; p0=p;
optn=optimset('Display','Iter','MaxIter',7); lb=[-un 4]; ub=[un 6]; 
s0=[0 0 0 0]'; p=fmincon('ipe_f',p0,[],[],[],[],lb,ub,'ipe_c',optn,s0);
[f,s]=ipe_f(p,s0); u=p([1:N+1]); tf=p(N+2); t=tf*[0:1/N:1]; 
th=s(1,:); q=s(2,:); x=s(3,:); v=s(4,:);
%save \book_do\pbcodes\ipe_fg p
% 
figure(1); clf; plot(t,[th;x;u],t,[th;x;u],'.'); grid;
axis([0 5.3 -1.2 3.2]); ylabel('th  x  u'); xlabel('Time');
%
figure(2); clf; plot(t,[v;q],t,[v;q],'.'); grid; 
ylabel('q  v'); xlabel('Time');
