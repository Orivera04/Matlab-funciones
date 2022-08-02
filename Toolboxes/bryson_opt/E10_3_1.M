% Script e10_3_1; Goddard sounding rocket problem; units m in mo, r in
% ro, (v,c) in sqrt(go*ro), g in go, (T,D) in mo*go, t in sqrt(ro/go),
% be in 1/ro, D=B*v^2*exp(-be*r)/2,  B=Cd*rhoo*ro*S/mo; used FSOLVE off-
% line to find t1 so that m-(1+v/c)D=0, t2 so that m-mf=0, tf so that
% v(tf)=0;                                                 1/96, 6/24/02
%
c=.5; be=500; mf=.6; Tmax=3.5; t1=.02353; t2=.0727; tf=.1990; B=620;  
y0=[1 0 1]'; [ta,ya]=ode23('gdd_1',[0 t1],y0); na=length(ta);
r=ya(na,1); v=ya(na,2); m=ya(na,3); D=B*v^2*exp(be*(1-r))/2; 
Ta=Tmax*ones(na,1); y1=ya(na,:)'; [tb,yb]=ode23('gdd_2',[t1 t2],y1);
nb=length(tb); m=yb(nb,3); r=yb(:,1); v=yb(:,2); m=yb(:,3);
D=B*(v.^2).*exp(be*(ones(nb,1)-r))/2; 
Tb=D+m./r.^2+m.*(be*(v.^2).*(ones(nb,1)+v/c)-2*v/c-v.^2/c^2)./...
   ((2+4*v/c+v.^2/c^2).*r.^2); y2=yb(nb,:)'; 
[tc,yc]=ode23('gdd_3',[t2 tf],y2); nc=length(tc); v=yc(nc,2);
Tc=zeros(nc,1);t=[ta; tb; tc]; y=[ya; yb; yc]; T=[Ta; Tb; Tc]; 
r=y(:,1); v=y(:,2); m=y(:,3); N=length(t); un=ones(N,1);
D=B*(v.^2).*exp(be*(un-r))/2; sf=m-(un+v/c).*D; r=y(:,1); v=y(:,2);
m=y(:,3); go=32.2; ro=3963*5280; vc=sqrt(go*ro); tc=sqrt(ro/go);
r=(r-un)*ro/5280; t=t*tc; v=v*vc/1000; 
%
figure(1); clf; subplot(211),plot(t,r); ylabel('Altitude (Miles)')
grid; axis([0 160 0 60]); subplot(212),plot(t,v); grid
axis([0 160 0 4]); ylabel('Velocity (kft/sec)'); xlabel('Time (sec)')
% 
figure(2); clf; subplot(211),plot(t,m); grid; ylabel('Mass m/m_o')
axis([0 160 0 1]); subplot(212), plot(t,T,t,2*sf,'r--'); grid
text(12,1.4,'2*(Switch Fcn)'); axis([0 160 0 4])    
text(25,3.2,'(Singular Arc)'); text(2,3.7,'Boost')
text(105,.3,'Coast'); text(30,3.7,'Sustain')
xlabel('Time (sec)'); ylabel('Thrust/m_og_o')
