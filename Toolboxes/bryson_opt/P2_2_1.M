% Script p2_2_1.m; DVDP for max xf w. gravity; dual of discrete
% Brachistochrone Pb.);                           3/97, 3/23/02
%
N=10; ga=[1:-1/(N-1):0]; s0=[0 0]'; tf=1; k=-7; tol=5e-5; 
[ga,s,la0]=dop0('dvdp0',ga,s0,tf,k,tol); gah=[ga ga(N)]; 
t=[0:1/N:1]; 
%
figure(1); clf; subplot(211), zohplot(t,2*gah/pi); grid
axis([0 1 0 1]); ylabel('2 \gamma/ pi');
subplot(212), plot(t,s); grid;  xlabel('t/t_f');
ylabel('v/at_f & x/at_f^2)');
	
