% Script f02_04.m; DVDP for max range with uc=Vy/h; plots
% optimal paths for Pb. 2.1.2(c);            11/96, 4/1/02
%
N=5; tf=2; dT=tf/N; x(1)=0; y(1)=0; 
for i=1:N, 
  th(i)=atan(dT*(N-i+.5)); y(i+1)=y(i)+dT*sin(th(i)); 
  x(i+1)=x(i)+dT*(y(i)+cos(th(i)))+dT^2*sin(th(i))/2; 
end;
N=40; dT=tf/N; x1(1)=0; y1(1)=0; 
for i=1:N, 
  th1(i)=atan(dT*(N-i+.5)); y1(i+1)=y1(i)+dT*sin(th1(i)); 
  x1(i+1)=x1(i)+dT*(y1(i)+cos(th1(i)))+dT^2*sin(th1(i))/2; 
end;
%
figure(1); plot(x,y,'r--',x1,y1,'b');  text(1.1,.3,'tf=2') 
legend('N=5','N=40',2); hold on; plot(x,y,'rs',x1,y1,'b.'); 
hold off; grid; xlabel('x/h'); ylabel('y/h')
print -deps2 \book_do\figures\f02_04
	
