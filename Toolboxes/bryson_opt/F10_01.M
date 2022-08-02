% Script f10_01.m; LQ pb. for 2nd order nonminimum phase system;
%                                                    9/96, 4/4/02
%
% Solution for UNBOUNDED u (impulse-singular-impulse):
tf=1.5; x1o=1; x2o=1; N=100; thi=tf*[0:1/N:1]; c=x1o+x2o;
a=exp(-2*tf); x10=2*c/(1-a); x20=-c*(1+a)/(1-a); 
x1i=x10*exp(-thi); x2i=x20*exp(thi)+x10*sinh(thi);
% 
% Solution for BOUNDED u; |u|<=uo; t1 & t2 found off-line with
% FSOLVE so that x1(tf)=0; x2(tf)=0;
x1o=1; x2o=1; tf=1.5; uo=8; t1=.4105; t2=1.3137; 
x11=x1o+(x2o+uo)*t1-uo*t1^2/2; x21=x2o-uo*t1;
dt1=t2-t1; x12=x11*exp(-dt1); x22=x21*exp(dt1)+x11*sinh(dt1);
dt2=tf-t2; x1f=x12+(x22-uo)*dt2+uo*dt2^2/2; x2f=x22+uo*dt2;
% (x1,x2) for u=uo, 0=<t=<t1:
th1=t1*[0:1/N:1]; N1=N+1;
x11t=x1o+(x2o+uo)*th1-uo*th1.^2/2; x21t=x2o-uo*th1;
% (x1,x2) on sing. arc, t1=<t=<t2:
th2=(t2-t1)*[0:1/N:1]; un=ones(1,N1); x12t=x11*exp(-th2);
x22t=x21*exp(th2)+x11*sinh(th2); th2=t1*un+th2;
% (x1,x2), u=-uo for t2=<t=<tf:
th3=(tf-t2)*[0:1/N:1]; x1ft=x12*un+(x22-uo)*th3+uo*th3.^2/2;
x2ft=x22*un+uo*th3; th3=t2*un+th3; 
%        
figure(1); clf; plot(x11t,x21t,x1i,x2i,'r--'); hold on; grid;
legend('Bang-Singular-Bang','Impulse-Singular-Impulse'); 
plot(x12t,x22t,'b',x1ft,x2ft,'b',x1o,x2o,'bo',x11t(N1),x21t(N1),...
   'bo',x12t(N1),x22t(N1),'bo',0,0,'bo',[x1o,x10],[x2o,x20],'r--',...
   [x1i(N1),0],[x2i(N1),0],'r--',x10,x20,'ro',x1i(N1),x2i(N1),'ro');
axis([0 4.5 -3 1.5]); axis('square'); text(1.1,1.1,'t=0'); 
text(3.85,-2.6,'t=t_1'); text(.78,-1.3,'t=t_2'); text(.2,.2,'t=t_f');
ylabel('x_2'); xlabel('x_1');
print -deps2 \book_do\figures\f10_01
%
figure(2); clf; subplot(211), plot(th1,x11t,thi,x1i,'r--'); hold on
legend('Bang-Singular-Bang','Impulse-Singular-Impulse') 
plot(th2,x12t,'b',th3,x1ft,'b'); grid; axis([0 tf 0 5]); ep=.003;
plot([ep ep],[x1o x10],'r--'); plot([tf-ep tf-ep],[0 x1i(N1)],'r--');  
plot(0,1,'ro',1.5,0,'ro'); hold off; ylabel('x_1'); subplot(212),
plot(th1,x21t,thi,x2i,'r--');
legend('Bang-Singular-Bang','Impulse-Singular-Impulse') 
hold on; plot(th2,x22t,'b',th3,x2ft,'b'); grid 
plot([ep ep],[x2o x20],'r--'); plot([ep ep],[x2o x20],'r--'); 
plot([tf-ep tf-ep],[0 x2i(N1)],'r--',0,1,'ro',1.5,0,'ro'); hold off
ylabel('x_2'); xlabel('Time'); axis([0 tf -3 2])
%print -deps2 \book_do\figures\f10_02
%
figure(3); clf; subplot(211),plot(th1,uo*un,thi,-x1i-x2i,'r--'); 
hold on; legend('Bang-Singular-Bang','Impulse-Singular-Impulse') 
plot(th2,-x12t-x22t,'b',th3,-uo*un,'b'); grid; axis([0 1.5 -10 10]);
plot([0 0],[0 uo],'r--'); plot([.01 .01],[15 -x1i(1)-x2i(1)],'r--');
plot([tf tf],[-10 0],'r--'); plot([t1 t1],[uo -x12t(1)-x22t(1)],'b');
plot([t2 t2],[-x12t(N1)-x22t(N1) -uo],'b');
plot([tf-.01,tf-.01],[-x1i(N1)-x2i(N1) -10],'r--'); hold off
ylabel('u'); xlabel('Time') 
%print -deps2 \book_do\figures\f10_03
