% Script p2_1_1.m; DVDP for max range with gravity; v in
% g*tf, (x,y) in g*tf^2; note MATLAB has no zero index so
% i=0 to N becomes i=1 to N+1;             12/92, 3/30/02
%
clear; N=5; d=2*N*sin(pi/(4*N)); n=cos(pi/(4*N))/(2*N*d);
for i=1:N, ga(i)=(pi/2)*(1-(i-.5)/N); end
for i=1:N+1,   
 x(i)=n*(i-1-sin(pi*(i-1)/N)/(2*sin(pi/(2*N))));
 y(i)=(n/(2*sin(pi/(2*N))))*(1-cos(pi*(i-1)/N));
end; g1h=[ga ga(N)]; t1=[0:1/N:1];  
%
N=40; d=2*N*sin(pi/(4*N)); n=cos(pi/(4*N))/(2*N*d);
for i=1:N, ga(i)=(pi/2)*(1-(i-.5)/N); end
for i=1:N+1,   
 x1(i)=n*(i-1-sin(pi*(i-1)/N)/(2*sin(pi/(2*N))));
 y1(i)=(n/(2*sin(pi/(2*N))))*(1-cos(pi*(i-1)/N));
end; g2h=[ga ga(N)]; t2=[0:1/N:1];
%
figure(1); clf; plot(x,-y,'r',x1,-y1,'b'); grid 
axis([0 .35 -.266 0]); xlabel('x/gt_f^2'); ylabel('y/gt_f^2')
legend('N=5','N=40'); hold on; plot(x,-y,'rs',x1,-y1,'b.');
hold off
%
figure(2); clf; zohplot(t1,2*g1h/pi); hold on
zohplot(t2,2*g2h/pi); grid; hold off; axis([0 1 0 1])
xlabel('t/t_f'); ylabel('2 \gamma / \pi') 
text(.61,.55,'N=5'); text(.41,.32,'N=40') 
