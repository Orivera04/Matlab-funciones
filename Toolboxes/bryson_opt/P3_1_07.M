% Script p3_1_07.m; DTDP for max uf with vf=0 and (xf,yf)
% specified; finds nu in analytic solution for be(i) to 
% satisfy terminal BCs using FSOLVE; s=[u v y x]'; 
%                                           2/97, 3/30/02
%
y1=[-1 2 -1]; 
optn=optimset('Display','Iter','MaxIter',200);
y1=fsolve('dtdpc_f',y1,optn); [f,u,v,y,x,th]=dtdpc_f(y1);
N=length(th); t=[0:1/N:1]; t1=[0:1/N:1-1/N];
%
figure(1); clf; subplot(211), zohplot(t1,th*180/pi); grid
ylabel('\theta (deg)'); subplot(212), plot(t,u,t,v); grid
xlabel('t/t_f'); ylabel('u/at_f & v/at_f');
% 
figure(2); clf; plot(x,y,x,y,'.',x(N+1),y(N+1),'o'); grid
axis([-.04 .24 0 .21]); xlabel('x/at_f^2') 
ylabel('y/at_f^2') 

	
	


