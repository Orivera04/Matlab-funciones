% Script p2_1_4.m; max xf with V(y)=1+y; discrete Fermat
% Pb. using FSOLVE with EL eqns; optimal path w. N=5 & N=40;
%                                              2/97, 7/24/02
%
tf=2; N=5; th0=[1:-1/N:1/N]; 
optn=optimset('Display','Iter','MaxIter',200);  
th=fsolve('dferm0',th0,optn,tf); [f,x,y]=dferm0(th,tf);
t=tf*[0:1/N:1]; c=180/pi; thh=c*[th th(N)];  
N=40; th0=[1:-1/N:1/N];  
th1=fsolve('dferm0',th0,optn,tf); [f,x1,y1]=dferm0(th1,tf);
t1=tf*[0:1/N:1]; th1h=c*[th1 th1(N)];
%
figure(1); clf; plot(x,y,'r--',x1,y1,'b'); grid; hold on
legend('N=5','N=40',2); plot(x,y,'rs',x1,y1,'b.');
xlabel('x/h'); ylabel('y/h'); text(1.65,1.2,'tf=2')
%
figure(2); clf; zohplot(t,thh,'r--'); hold on; 
zohplot(t1,th1h,'b'); grid; legend('N=5','N=40'); hold off 
xlabel('Time'); ylabel('\theta (deg)')
	
	