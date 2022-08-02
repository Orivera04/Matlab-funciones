% Script p10_2_2.m; solves singular LQ pb. for oscillatory 
% NMP system;                                9/98, 3/30/02
%
% Solution for UNBOUNDED u (impulse-singular-impulse):
tf=1.5; x1o=2; x2o=2; N=100; ti=tf*[0:1/N:1]; c=x1o+x2o;
a=exp(-2*tf); x10=c/(1-a); x20=-c*a/(1-a);
x1i=x10*exp(-ti); x2i=x20*exp(ti);
% 
% Solution for BOUNDED u; |u|<=uo; t1 & t2 found w. FSOLVE
% so that x1(tf)=0; x2(tf)=0;
t1=.13; t2=1.43; p0=[t1 t2]; optn=optimset;
p=fsolve('oscnmp',p0,optn); t1=p(1); t2=p(2);
x11=-uo+(x1o+uo)*cos(t1)+(x2o+uo)*sin(t1);
x21=-uo-(x1o+uo)*sin(t1)+(x2o+uo)*cos(t1);
dt1=t2-t1; x12=x11*exp(-dt1); x22=x21*exp(dt1); dt2=tf-t2; 
x1f=uo+(x12-uo)*cos(dt2)+(x22-uo)*sin(dt2);
x2f=uo-(x12-uo)*sin(dt2)+(x22-uo)*cos(dt2);
% (x1,x2) for u=uo, 0=<t=<t1:
th1=t1*[0:1/N:1]; N1=N+1; un=ones(1,N1);
x11t=-uo*un+(x1o+uo)*cos(th1)+(x2o+uo)*sin(th1);
x21t=-uo*un-(x1o+uo)*sin(th1)+(x2o+uo)*cos(th1);
% (x1,x2) on sing. arc, t1=<t=<t2:
th2=dt1*[0:1/N:1]; un=ones(1,N1); x12t=x11*exp(-th2);
x22t=x21*exp(th2); th2=t1*un+th2;
% (x1,x2), u=-uo for t2=<t=<tf:
th3=dt2*[0:1/N:1]; x1ft=uo*un+(x12-uo)*cos(th3)+...
    (x22-uo)*sin(th3);
x2ft=uo*un-(x12-uo)*sin(th3)+(x22-uo)*cos(th3);
th3=t2*un+th3; 
%        
figure(1); clf; plot(x11t,x21t,x1i,x2i,'r--'); hold on; grid;
legend('Bang-Singular-Bang','Impulse-Singular-Impulse'); 
plot(x12t,x22t,'b',x1ft,x2ft,'b',x1o,x2o,'bo',x11t(N1),x21t(N1),...
   'bo',x12t(N1),x22t(N1),'bo',0,0,'bo',[x1o,x10],[x2o,x20],'r--',...
   [x1i(N1),0],[x2i(N1),0],'r--',x10,x20,'ro',x1i(N1),x2i(N1),'ro');
axis([0 5 -2 3]); axis('square'); text(2.1,2.1,'t=0'); 
text(3.85,-2.6,'t=t1'); text(.78,-1.3,'t=t2'); text(.2,.2,'t=tf');
ylabel('x_2'); xlabel('x_1');
%
figure(2); clf; subplot(211), plot(th1,x11t,ti,x1i,'r--'); hold on;
legend('Bang-Singular-Bang','Impulse-Singular-Impulse'); 
plot(th2,x12t,'b',th3,x1ft,'b'); grid; axis([0 tf 0 5]); ep=.003;
plot([ep ep],[x1o x10],'r--',[tf-ep tf-ep],[0 x1i(N1)],'r--',...  
  0,2,'ro',1.5,0,'ro'); hold off; ylabel('x_1'); subplot(212),
plot(th1,x21t,ti,x2i,'r--',th2,x22t,'b',th3,x2ft,'b',[ep ep],...
   [x2o x20],'r--',[ep ep],[x2o x20],'r--',[tf-ep tf-ep],...
   [0 x2i(N1)],'r--',0,2,'ro',1.5,0,'ro'); grid;
ylabel('x_2'); xlabel('Time'); axis([0 tf -3 2]);
%
figure(3); clf; subplot(211),plot(th1,uo*un,ti,-x1i-x2i,'r--'); 
hold on; legend('Bang-Singular-Bang','Impulse-Singular-Impulse'); 
plot(th2,-x12t-x22t,'b',th3,-uo*un,'b',[0 0],[0 uo],'r--',[.01 .01],...
   [16 -x1i(1)-x2i(1)],'r--',[tf tf],[-10 0],'r--',[t1 t1],...
   [uo -x12t(1)-x22t(1)],'b',[t2 t2],[-x12t(N1)-x22t(N1) -uo],'b',...
   [tf-.01,tf-.01],[-x1i(N1)-x2i(N1) -16],'r--'); hold off;
grid; axis([0 1.5 -16 16]); ylabel('u');  xlabel('Time'); 