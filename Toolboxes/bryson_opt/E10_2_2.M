% Script e10_2_2.m; RL vs. Q/R & time response for Navion lateral system
% controlled by rudder alone; x=[v r p phi]'; J=int(Q*phi^2+dr^2)dt;
%                                                          1/96, 6/24/02
%
A=[-.254 -1.76 0 .322; 2.55 -.76 -.35 0; -9.08 2.19 -8.4 0; ...
   0 0 1 0]; B=[.1246 -4.6 2.55 0]'; C=[0 0 0 1];
z1=-3.608; z2=6.988; nu1=2.55*[1 -z1-z2 z1*z2];
nu2=[nu1(1) -nu1(2) nu1(3)]; num=conv(nu1,nu2); % Num. for SRL
p1=-8.433; p2=-.009; p3=-.486+2.333*j; p4=conj(p3);
de1=conv([1 -p1],[1 -p2]); de2=conv([1 -p3],[1  -p4]);
de3=conv(de1,de2); de4=[de3(1) -de3(2)	de3(3) -de3(4) de3(5)];
den=conv(de3,de4);		                 % Denominator for SRL
Q=[.01 .03 .1 .3 1 3 10 30 100 300 1000 3000];
for i=1:12, [k(i,:),S,ev(:,i)]=lqr(A,B,C'*Q(i)*C,1); end
%
figure(1); clf; rlocus(num,den); hold on; plot(real(ev),imag(ev),'x');
grid; plot(-6.988,0,'o',-3.608,0,'o'); hold off; axis('square');
text(-8,1,'Reflected Zero'); text(-7.6,8.3,'Q=3000');
text(-5.8,7,'1000'); text(-3.8,5.5,'300'); text(-1.9,4.1,'30'); 
text(-.6,3.2,'.01'); axis([-10 0 -1 9]); 
xlabel('Real(s) 1/sec'); ylabel('Imag(s) 1/sec');
%
% Navion banked turn with minimum integral-square phi, |dr|=< dr_max;
% used FSOLVE to find p=[t1 t2 t3 c] so that f=x(t3)-cV=0, where V
% is eigvec of stable closed-loop mode with eigval s=-3.6081 (the 
% noncancelled reflected zero);        
%
p=[.390265 .774973 .967715 11.1062]; t1=p(1); t2=p(2); t3=p(3);
c=p(4); t4=2; V=[.4412 .8974 0 0]'; y0=[.407 1.77 0 10]'; 
[ta,ya]=ode23('bkt_1',[0 t1],y0); na=length(ta);   
y1=ya(na,:)'; [tb,yb]=ode23('bkt_2',[t1 t2],y1);
nb=length(tb); y2=yb(nb,:)'; 
[tc,yc]=ode23('bkt_1',[t2 t3],y2); nc=length(tc);
y3=yc(nc,:)'; [td,yd]=ode23('bkt_3',[t3 t4],y3);
f=y3-c*V; K=[-3.5608 .8588 -1.9685 -9.8882];
%
% LQR response with Q=5:
k5=lqr(A,B,C'*5*C,1); xu=[A B; C 0]\[0 0 0 0 10]';
xo=xu(1:4); [y,x,t]=initial(A-B*k5,B,C,0,xo); dr=-k5*x';
%
figure(2); clf; subplot(211); plot(ta,ya(:,4),t,y,'r--'); hold on 
legend('With Hard Bounds','LQR with Q=5'); grid; axis([0 2 -2 12]) 
plot(tb,yb(:,4),'b',tc,yc(:,4),'b',td,yd(:,4),'b'); hold off
ylabel('\phi (crad)')
subplot(212); plot(ta,25*ones(1,na),tb,-25*ones(1,nb),'b',...
  tc,25*ones(1,nc),'b',td,-yd*K','b'); grid; axis([0 2 -30 30])
hold on; plot(t,dr,'r--'); plot([t1 t1],[25 -25]);
plot([t2 t2],[25 -25]); plot([t3 t3],[25 9]); hold off 
ylabel('\delta r (crad)'); xlabel('Time (sec)')
%
figure(3); clf; subplot(211);
plot(ta,ya(:,[2 3]),tb,yb(:,[2 3]),tc,yc(:,[2 3]),td,yd(:,[2 3])); grid
hold on; plot(t,x(:,[2 3]),'--'); hold off; axis([0 2 -40 40])
ylabel('crad/sec'); text(.9,25,'r'); text(.8,-25,'p')
subplot(212); plot(ta,ya(:,1),tb,yb(:,1),tc,yc(:,1),td,yd(:,1)); grid
hold on; plot(t,x(:,1),'--'); hold off
ylabel('v (ft/sec)'); xlabel('Time (sec)'); axis([0 2 0 20])