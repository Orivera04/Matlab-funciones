% Script stage.m; Ross two-stage pb; m(0)=1, m(t1-)=.8, m(t1+)=.7,
% m(t2)=.5; coast to tf; y=[r v m]'; t1 & t2 found by integrating
% mdot=-T/c; tf interpolated so that v(tf)=0;             9/10/02
%
t1=1/35; t2=2*t1; tf=.291;        
[ta,ya]=ode23('stage_o',[0 t1],[1 0 1]'); Na=length(ta);
r1=ya(Na,1); v1=ya(Na,2);
[tb,yb]=ode23('stage_o',[t1 t2],[r1 v1 .7]'); Nb=length(tb);
r2=yb(Nb,1); v2=yb(Nb,2);
[tc,yc]=ode23('stage_o',[t2 tf],[r2 v2 .5]'); Nc=length(tc);
%
figure(1); clf; subplot(211),plot(ta,ya(:,2:3)); grid; hold on 
legend('Velocity','Mass'); plot(tb,yb(:,2:3)); 
plot(tc,yc(:,2:3),[t1 t1],[.7 .8],'g',[t2 t2],[0 1],'r');
plot([0 t2],[1 1],'r',[t2 tf],[0 0],'r'); 
text(.065,.9,'T/T_{max}'); hold off; axis([0 .3 0 1.1])
subplot(212), plot(ta,ya(:,1)-ones(Na,1)); grid; hold on
plot(tb,yb(:,1)-ones(Nb,1)); plot(tc,yc(:,1)-ones(Nc,1)); 
hold off; axis([0 .3 0 .032]); xlabel('Time')
ylabel('(r-r_0)/r_0'); 