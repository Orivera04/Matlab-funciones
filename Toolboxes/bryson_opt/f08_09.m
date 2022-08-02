% Script f08_09.m; min time paths in a region of with
% discontinuous velocity;                7/98, 4/4/02
%
b=sqrt(3); Ta=[2/b 1.25:.25:3.25 2*b]; Na=length(Ta); 
un=ones(1,Na); ya=sqrt(b*Ta/2-3*un/4)+1.5*un-b*Ta/2;
xa=2*Ta-2*b*un+b*ya; th2=[0:5:90]*pi/180; N=length(th2);
un=ones(1,N); th1=asin(sin(th2)/2); x1=tan(th1);
t1=un./cos(th1);
%
figure(1); clf; t2a=[1.25:.25:3.25 2*b]; N1=length(t2a);
for i=1:N1, t2=t2a(i); x=x1+2*(t2*un-t1).*sin(th2); 
   xc(i)=x1(N)+2*(t2-t1(N)); y=un+2*(t2*un-t1).*cos(th2);
   plot(x,y,'r--'); hold on; end
th2a=[10:10:90]*pi/180; yf=3.1;
for i=1:9, th2=th2a(i); th1=asin(sin(th2)/2);
   x1=tan(th1); xf=x1+(yf-1)*tan(th2); plot([x1 xf],...
   [1 yf],'b',[0 x1],[0 1],'b');
end 
for i=1:Na, plot([0 xa(i)],[0 ya(i)],'b',[xa(i)-...
   (1-ya(i))/b xa(i)],[1 ya(i)],'b'); end
al=[0:5:90]*pi/180; d=[.25:.25:1]; for i=1:4, 
   xb=d(i)*cos(al); yb=d(i)*sin(al); plot(xb,yb,'r--'); 
end
plot(xa,ya,'g-.',[3.75-1/b 3.75],[1 0],'b',...
   [4-1/b 4],[1 0],'b',[4.25-1/b 4.25],[1 0],'b',...
   [4.5-1/b 4.5],[1 0],'b',[0 2*b],[0 0],'b',2*b,...
   0,'ro',0,0,'ro',[0 0],[0 3],'b',1/b,1,'ro',...
   [0 1/b],[0 1],'b'); d=[1.25:.25:3.25];
for i=1:9, alm=atan(ya(i+1)/xa(i+1)); al=[0:pi/180:alm];
   xb=d(i)*cos(al); yb=d(i)*sin(al); plot(xb,yb,'r--');
end
for i=1:10, plot([xa(i+1) xc(i)],[ya(i+1) 1],'r--'); end
hold off; grid; axis([-.1 4 -.1 3.1]); ylabel('y/h'); 
text(2.1,.8,'Locus of Darboux Points');
text(3.1,.1,'Pseudo-Conjugate Point'); xlabel('x/h'); 
text(3.05,2.2,'ct/h=2.50'); text(3.55,2.4,'2.75'); 
text(2.55,2.05,'2.25'); text(3.85,2.8,'3.00'); 
text(2.15,1.8,'2.00'); text(1.7,1.6,'1.75'); 
text(1.2,1.37,'1.50');text(.72,1.22,'1.25');
text(.73,.77,'1.00'); text(.57,.6,'.75');
text(.36,.42,'.50'); text(.2,.25,'.25'); 
text(1.07,.75,'1.25');
%print -deps2 \book_do\figures\f08_09