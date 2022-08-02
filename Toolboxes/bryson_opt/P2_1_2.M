% Script p2_1_2.m; DVDP for max range with uc=Vy/h;
% plots optimal paths for part (c);      11/96, 3/30/02
%
N=40; tf=2; dT=tf/N; x=zeros(1,N+1); y=x; th=zeros(1,N);
for i=1:N, 
  th(i)=atan(dT*(N-i+.5)); y(i+1)=y(i)+dT*sin(th(i)); 
  x(i+1)=x(i)+dT*(y(i)+cos(th(i)))+dT^2*sin(th(i))/2; 
end;
%
figure(1); clf; plot(x,y,'o'); grid; xlabel('x');
ylabel('y'); hold on; clear;
%
N=5; tf=2; dT=tf/N; x=zeros(1,N+1); y=x; th=zeros(1,N);
for i=1:N, 
  th(i)=atan(dT*(N-i+.5)); y(i+1)=y(i)+dT*sin(th(i)); 
  x(i+1)=x(i)+dT*(y(i)+cos(th(i)))+dT^2*sin(th(i))/2; 
end;
%
figure(1); plot(x,y,'rx'); hold off; text(1.1,.3,'t_f=2') 
text(1.1,.6,'o - N = 40'); text(1.1,.45,'x - N = 5')
	
