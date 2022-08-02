% Script f02_06.m; max xf with V(y)=1+y; discrete Fermat Pb. using 
% FSOLVE with E-L eqns; optimal path w. N=5 & N=40;  2/97, 1/13/98
%
tf=2; N=5; th0=[1:-1/N:1/N]; 
optn=optimset('Display','Iter','MaxIter',200);  
th=fsolve('dferm0',th0,optn,tf); [f,x,y]=dferm0(th,tf);
N=40; th0=[1:-1/N:1/N]; th1=fsolve('dferm0',th0,optn,tf);
[f,x1,y1]=dferm0(th1,tf);
%
figure(1); clf; plot(x,y,'r--',x1,y1,'b'); grid; hold on
legend('N=5','N=40',2); plot(x,y,'rs',x1,y1,'b.'); hold off
xlabel('x/h'); ylabel('y/h'); text(1.7,1.7,'tf=2')
%print -deps2 \book_do\figures\f02_06
		
	