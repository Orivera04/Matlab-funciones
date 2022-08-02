% Script f10_11; max range rocket problem (S.E. Ross, 1957)
% by inverse optimization using v(t) as key state variable; 
% s=[v ga h x m]'; control=T; m in mf, (v,c) in sqrt(gv*lc),
% (h,x,1/al)in lc, t in sqrt(lc/gv), (T,D) in gv*mf;
% lc=2mf/CdS*rhoo); p=[v(1:N+1) ga0 tf];         8/95, 4/5/02
%
hf=100000;		                       % Final altitude in ft
N=40; un1=ones(1,N+1); 
optn=optimset('Display','Iter','MaxIter',5);
ub=[3*un1 pi/2 6]; lb=[un1 .5 2]; 
%p=[1.5*un1 1.3 4];   		            % Crude initial guess
load rkt; p=p100;                        % Converged solution
p=fmincon('rkt_f',p,[],[],[],[],lb,ub,'rkt_c',optn,N,hf);
%
[f,v,x,h,m,T]=rkt_f(p,N,hf); rhoo=.0021;
CdS=.47; gv=32.2; mf=500/gv; lc=2*mf/(CdS*rhoo);
tc=sqrt(lc/gv); vc=sqrt(gv*lc);
tf=p(N+3); dt=tf/N;
t=tf*tc*[0:N]/N; tb=tf*tc*[.5:N-.5]/N;
%
figure(1); clf; x=lc*x/1000; h=h*lc/1000; 
plot(x,h,x,h,'.',x(41),h(41),'ro'); grid; axis([0 225 0 150])
xlabel('x (kft)'); ylabel('h (kft)')
%
figure(2); subplot(211); T=T*mf*gv/1000; 
plot(tb,T,tb,T,'.'); grid
axis([0 175 0 2.2]); xlabel('Time (sec)')
ylabel('Thrust (klb)'); text(5,1.9,'Boost')
text(28,1.75,'Sustain (Singular Arc)') 
text(58,.2,'Coast')
subplot(212); v=v*vc/1000;
plot(t,v,t,v,'.'); grid; axis([0 175 0 2.5])
xlabel('Time (sec)'); ylabel('Velocity (kft/sec)')
%print -deps2 \book_do\figures\f10_11
   
   	

