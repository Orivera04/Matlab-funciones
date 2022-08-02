% Script p9_3_07.m; min fuel horiz. translation of S/C over a
% distance l with |th|<=th0; t in sqrt(l/g), y in l, v in sqrt(gl);
%                                                       8/98, 3/31/02
%
th0=pi/3; st=sin(th0); ct=cos(th0); tt=tan(th0); un=ones(1,21); 
tf=2/sqrt((th0+sin(2*th0)/2)*st^2+st*ct^3); t1f=tf*ct^2/2; t2f=tf-t1f;
t1=t1f*[0:.05:1]; v1=t1*tt; y1=t1.^2*tt/2; th1=180*th0*un/pi;
t2=[t1f:(t2f-t1f)/20:t2f]; th2=asin((un-2*t2/tf)/st);
v2=tf*st*cos(th2)/2; y2=y1(21)+(tf^2/8)*st^2*(th0*un-th2+(sin(2*th0)...
    *un-sin(2*th2))/2); t3=[t2f:(tf-t2f)/20:tf]; th3=-th1; 
v3=(tf*un-t3)*tan(th0); y3=y2(21)+v2(21)*(t3-t2f*un)-tt*...
    (t3-t2f*un).^2/2; t1=t1/tf; t2=t2/tf; t3=t3/tf;
%
figure(1); clf; subplot(311); plot(t1,v1,t2,v2,'b',t3,v3,'b',...
 t2(1),v2(1),'ro',t3(1),v3(1),'ro'); grid; ylabel('v/sqrt(gl)');
subplot(312), plot(t1,th1,t2,th2*180/pi,'b',t3,th3,'b',...
 t2(1),th2(1)*180/pi,'ro',t3(1),th3(1),'ro'); grid;
ylabel('\theta (deg)'); axis([0 1 -70 70]); subplot(313);
plot(t1,y1,t2,y2,'b',t3,y3,'b',t2(1),y2(1),'ro',t3(1),y3(1),'ro');
grid; ylabel('y/l'); xlabel('t/t_f');
   