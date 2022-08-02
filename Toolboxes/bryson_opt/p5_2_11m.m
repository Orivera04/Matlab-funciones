% Script p5_2_11m.m; movie of robot bicycle turn; x=[ph p de ps y]';
% ctrl=u; indpt variable=s=distance along path in units of l=wheelbase;
% ydot=-ps; taking rho=h, V=15 mph;                       7/99, 3/31/02
%
V=15*88/60; l=40/12; h=3; b=20/12; g=32.2; d=g*l^2/(h*V^2); a=l/h; 
c=b/h; A=[0 1 0 0 0; d 0 -a 0 0; 0 0 0 0 0; 0 0 1 0 0; 0 0 0 -1 0];
Bu=[0 -c 1 0 0]'; Cc=zeros(1,5); sf=20; Ns=100; Qdc=0; Rd=1; C0=eye(5);
Q0=1e5*C0; x0=[0 0 0 0 -.4]'; Cf=C0; Qf=1e5*Cf; yf=zeros(5,1);
s=sf*[0:1/Ns:1]; yc=zeros(1,Ns+1); [Ph,Gu]=c2d(A,Bu,sf/Ns); 
[x,ud]=tdlqf(Ph,Gu,Rd,C0,Q0,x0,Cc,Qdc,yc,Cf,Qf,yf); uh=[ud ud(Ns)];
ph=x(1,:); ps=x(4,:); de=x(3,:); yb=x(5,:); yf=yb-ps; z=180/pi; 
%
figure(1); clf; subplot(311), plot(s,yb,s,yf,'g-.'); grid; 
axis([0 sf -.5 .1]); legend('y_b','y_f',4); subplot(312); 
plot(s,z*ps,s,z*ph,'r--',s,z*de,'g-.'); grid; ylabel('deg'); 
axis([0 sf -4 3]); legend('\psi','\phi','\delta',4); subplot(313), 
zohplot(s,z*uh); grid; axis([0 sf -1 2.5]); ylabel('u (deg/sec)');
xlabel('x/l');
%
figure(2); clf; moviein(Ns+1);    
for j=[1:Ns+1], xb=2+s(j); yb=x(5,j); ph=2*x(1,j); ps=x(4,j); de=x(3,j);
   cs=cos(ps); ss=sin(ps); xf=xb+4*cs; yf=yb-4*ss; 
   cf=cos(ps+de); sf=sin(ps+de); hold off 
   for i=1:81, th=(i-1)*2*pi/80; x1=cos(th); y1=.5*ph*sin(th);
    x2(i)=xb+cs*x1+ss*y1; y2(i)=yb-ss*x1+cs*y1;
    x3(i)=xf+cf*x1+sf*y1; y3(i)=yf-sf*x1+cf*y1;
   end
   plot(x2,y2,x3,y3,'b',[1 27],[0 0],'r--',[1 27],-[.4 .4],'r--',...
      [xb xf],[yb yf],'b',(xb+xf)/2,ph+(yb+yf)/2,'bo',...
      [xb (xb+xf)/2],[yb ph+(yb+yf)/2],'b',...
      [(xb+xf)/2 xf],[ph+(yb+yf)/2 yf],'b');
   axis([1 27 -2.4 .8]); axis('square'); axis off; hold on; 
   m(:,j)=getframe; 
end; movie(m,-1,10)
%
figure(3); clf;    
for j=[1:16:97 101], xb=2+s(j); yb=x(5,j); ph=2*x(1,j); ps=x(4,j); de=x(3,j);
   cs=cos(ps); ss=sin(ps); xf=xb+4*cs; yf=yb-4*ss; 
   cf=cos(ps+de); sf=sin(ps+de);  
   for i=1:81, th=(i-1)*2*pi/80; x1=cos(th); y1=.5*ph*sin(th);
    x2(i)=xb+cs*x1+ss*y1; y2(i)=yb-ss*x1+cs*y1;
    x3(i)=xf+cf*x1+sf*y1; y3(i)=yf-sf*x1+cf*y1;
   end
   plot(x2,y2,x3,y3,'b',[1 27],[0 0],'r--',[1 27],-[.4 .4],'r--',...
      [xb xf],[yb yf],'b',(xb+xf)/2,ph+(yb+yf)/2,'bo',...
      [xb (xb+xf)/2],[yb ph+(yb+yf)/2],'b',...
      [(xb+xf)/2 xf],[ph+(yb+yf)/2 yf],'b'); axis([1 27 -2.4 .8]);
   axis('square'); axis off; hold on; 
end; hold off 



