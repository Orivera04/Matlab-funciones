% Script p3_5_07f.m; DTDP for max uf with vf=0 and (xf,yf) specified 
% using DOPCF;                                         3/97, 5/27/02
%
N=40; s0=zeros(4,1); la0=[-.214 .849 2.026 -1.214]; 
c=180/pi; th0=104/c; tf=1; name='dtdpcx'; 
optn=optimset('Display','Iter','MaxIter',500); 
nu=[-1.175 2.023 -1.214]; p0=[la0 nu]; 
p=fsolve('dopcf',p0,optn,name,th0,s0,tf,N);
[f,s,th]=dopcf(p,name,th0,s0,tf,N); thh=c*[th th(N)];
u=s(1,:); v=s(2,:); x=s(4,:); y=s(3,:); t=[0:1/N:1];
% 
figure(1); clf; plot(x,y,x,y,'.'); grid; axis([-.04 .24 0 .21])  
xlabel('x/at_f^2');  ylabel('y/at_f^2') 
%
figure(2); clf; subplot(211), zohplot(t,thh); grid 
ylabel('\theta (deg)'); subplot(212), plot(t,u,t,v,'r--'); grid
xlabel('t/t_f'); legend('u/at_f','v/at_f',2)



	


