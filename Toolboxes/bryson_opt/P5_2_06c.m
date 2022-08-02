% Script p5_2_06c.m; undamped pendulum using analytical soln. for 
% case sv-->infty, sy-->infty; s=[y v]';             5/98, 6/26/02
%
N=100; tf=10*pi; D=2/(tf^2-sin(tf)^2); A=D*(tf*cos(tf)+sin(tf));
B=D*tf*sin(tf); F=-A/2; t=tf*[0:1/N:1]; T=tf*ones(1,N+1)-t;
y=F*sin(T)+A*T.*cos(T)/2+B*T.*sin(T)/2; a=-A*sin(T)+B*cos(T); 
v=-F*cos(T)+A*(T.*sin(T)-cos(T))/2-B*(T.*cos(T)+sin(T))/2; t=t/tf;
%  
figure(1); clf; subplot(211), plot(t,y,t,v,'r--'); grid
legend('y','v'); subplot(212), plot(t,a); grid; ylabel('a')
xlabel('t/t_f')

