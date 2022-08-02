% Script p9_3_14a.m; min time pick-and-place motion of two-link robot
% arm using inverse dynamic optimization; links of length L & mass m, 
% tip mass=mu*m, (ue,us)= shoulder,elbow) torques in units of max
% torque=Qmax; time in units of tc=sqrt(m*L^2/Qmax), (oms,ome)=
% angular velocities of (shoulder,elbow) links in 1/tc, D=tip 
% distance traveled in units of L (max=4), tf in units of tc; 
%                                                     12/96, 3/29/02 
%
N=40; D=3.9; un=ones(1,N-1); 
p0=[-0.3195  -0.6678  -1.0301  -1.2869  -1.3514  -1.3094  -1.2455...
  	-1.1881  -1.1429  -1.1096  -1.0872  -1.0751  -1.0736  -1.0843...
    -1.1105  -1.1257  -1.0535  -0.9445  -0.7934  -0.6385  -0.7934...
    -0.9445  -1.0535  -1.1257  -1.1105  -1.0843  -1.0736  -1.0751...
    -1.0872  -1.1096  -1.1429  -1.1881  -1.2455  -1.3094  -1.3514...
    -1.2869  -1.0301  -0.6678  -0.3195   0.4073   0.8525   1.3165...
     1.6428   1.7186   1.6565   1.5664   1.4844   1.4167   1.3618...
	 1.3169   1.2787   1.2439   1.2085   1.1669   1.1389   1.2070...
     1.3399   1.5432   1.7678   1.5432   1.3399   1.2070   1.1389...
     1.1669   1.2085   1.2439   1.2787   1.3169   1.3618   1.4167...
     1.4844   1.5664   1.6565   1.7186   1.6428   1.3165   0.8525...
     0.4073  -0.2121   2.9119];                     % Converged values
lb=[-2*un -2*un -.5 0]; ub=[2*un 2*un 1 4]; tf=2.9119; t=tf*[0:N]/N;
%tf=2.9; t=tf*[0:N]/N; a=sin(pi*t/tf); p0=[-a(2:N) a(2:N) 0 tf];  
optn=optimset('display','iter');
p=fmincon('robot_f',p0,[],[],[],[],lb,ub,'robot_c',optn,N,D);
[f,ome,oms,the,ths,tf]=robot_f(p,N,D); [c,ceq,us,ue]=robot_c(p,N,D);
tb=tf*[.5:N-.5]/N;  
%
figure(1); clf; subplot(411), plot(tb/tf,ue,tb/tf,ue,'.'); grid;
ylabel('u_e'); subplot(412), plot(tb/tf,us,tb/tf,us,'.'); grid
ylabel('u_s'); subplot(413), plot(t/tf,ome-oms,t/tf,ome-oms,'.');
grid; axis([0 1 0 4]); ylabel('\omega_e-\omega_s'); subplot(414), 
plot(t/tf,oms,t/tf,oms,'.'); grid; ylabel('\omega_s'); 
axis([0 1 -3 0]); xlabel('t/t_f');
%
% Change ths(t) to make ths(tf)=pi-ths(0), then plot:
dths=(pi+ths(N+1))/2; ths=ths-dths*ones(1,N+1);
xe=cos(ths); ye=sin(ths); xt=xe+cos(the+ths); yt=ye+sin(the+ths);
figure(2); clf; for i=1:N+1, 
 x1=[0 xe(i)]; y1=[0 ye(i)]; x2=[xe(i) xt(i)]; y2=[ye(i) yt(i)];
 plot(x1,y1,x2,y2,'b',xt(i),yt(i),'ro'); axis([-2 2 -3 1]); 
 axis('square'); axis off; pause(.1); hold on;
end; hold off
%
figure(3); clf; e=180/pi; subplot(211), 
plot(t/tf,e*the,t/tf,e*the,'.'); grid; ylabel('\theta_e (deg)'); 
axis([0 1 -50 400])
subplot(212), plot(t/tf,e*ths,t/tf,e*ths,'.'); grid; 
axis([0 1 -180 0]); ylabel('\theta_s (deg)'); xlabel('t/t_f')

        