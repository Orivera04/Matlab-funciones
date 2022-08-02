% Script e02_2_2.m; DVDP for max range w. gravity using MATLAB
% code FMINUNC; s=[v x]';                       11/94, 6/24/02
%	
flg=2; N=5; optn=optimset('Display','Iter','MaxIter',34); 
s0=[0 0]'; tf=1; ga=[1:-1/(N-1):0];  
ga=fminunc('dvdp_f',ga,optn,s0,tf,N);
[f,v,x]=dvdp_f(ga,s0,tf,N); t=[0:1/N:1]; gah=[ga ga(N)];
%
figure(1); clf; subplot(211), zohplot(t,2*gah/pi); grid
axis([0 1 0 1]); ylabel('2\gamma/\pi'); subplot(212)
plot(t,v,t,x,'r--'); grid; xlabel('t/t_f')
legend('v/gt_f','x/gt_f^2',2); 

	  




        
