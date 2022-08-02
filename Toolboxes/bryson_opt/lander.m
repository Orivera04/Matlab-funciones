% Script lander.m; 1 DOF moon landing pb. (I. Michael Ross); 
% h in units of h0, v in units of sqrt(g*h0), (t,Isp) in 
% sqrt(h0/g), m in m0, (T,Tmax) in m0*g, J in m0*v0; 9/11/02
%
tic; v0=-.05; Isp=1; Tmax=.5; ts=.3; tf=2; p0=[ts tf]';
optn=optimset('Display','Iter','MaxIter',10);
p=fsolve('lander_dyn',p0,optn,v0,Isp,Tmax); ts=p(1); tf=p(2); 
[f,t,s]=lander_dyn(p,v0,Isp,Tmax); h=s(:,1); v=s(:,2); m=s(:,3);
t1=ts*[0:.1:1]'; un=ones(11,1); v1=v0*un-t1; 
h1=un-v0*t1-t1.^2/2; m1=un;
t=[t1; t]; h=[h1; h]; v=[v1; v]; m=[m1; m];
%
figure(1); clf; subplot(211), plot(t,h,t,m,'r--',[ts ts],...
   [0 1],'b--',[tf tf],[0 1],'b--'); grid
legend('h/h_0','m/m_0'); axis([0 2.2 0 1]); subplot(212)
plot(t,v,[ts ts],[-1 0],'b--',[tf tf],[-1 0],'b--'); grid
axis([0 2.2 -.8 0]); ylabel('v/sqrt(g*h0)')
xlabel('t*sqrt(g/h_0)')
toc