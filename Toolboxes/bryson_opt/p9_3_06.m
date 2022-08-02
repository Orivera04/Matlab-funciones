% Script p9_3_06.m; min time to theta=q=0 for qdot=u,
% thetadot=q-tau*u with |u|<=umax; t in units of tau, u in 
% umax, q in umax*tau, theta in umax*tau^2;       8/98, 3/31/02
%
q=[0:.02:1.5]; N=length(q); un=ones(1,N); th=.5*un-(q+un).^2/2;
q1=[-1:.02:1.5]; N1=length(q1); un1=ones(1,N1); 
th1=1.5*un1-(q1+un1).^2/2; q2=[-1.4:.05:1.5]; N2=length(q2); 
un2=ones(1,N2); th2=2.5*un2-(q2+un2).^2/2; 
%
figure(1); clf; plot(th,q,-th,-q,'b',0,0,'ro',th1,q1,'r--',...
    -th1,-q1,'r--',th2,q2,'r--',-th2,-q2,'r--'); grid
xlabel('\theta/u_{max}\tau^2'); ylabel('q/u_{max}\tau')
text(1.5,.7,'u = u_{max}'); text(-1.8,-.8,'u = - u_{max}')
   