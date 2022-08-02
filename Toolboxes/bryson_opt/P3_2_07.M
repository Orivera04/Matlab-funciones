% Script p3_2_7.m; DTDP for max uf with vf=0 and (xf,yf) spec.
% using DOPC;                                   1/93, 3/31/02
%
N=40; th0=(pi/3)*[1:-2/N:-1+2/N]; so=zeros(4,1); tf=1; k=-15;
tol=1e-4; mxit=60; [th,s,nu,la0]=dopc('dtdpcx',th0,so,tf,...
    k,tol,mxit); u=s(1,:); v=s(2,:); x=s(4,:); y=s(3,:); 
thh=180*[th th(N)]/pi; t=[0:1/N:1]; 
% 
figure(1); clf; plot(x,y,x,y,'b.'); axis([-.04 .24 0 .21]);  
grid; xlabel('x/at_f^2');  ylabel('y/at_f^2'); 
%
figure(2); clf; subplot(211), zohplot(t,thh); grid;
ylabel('\theta (deg)'); subplot(212), plot(t,u,t,v,'r--');
grid; xlabel('t/t_f'); legend('u/at_f','v/at_f',2);


	


