% Script hochb.m; hom. chauf. bang-bang soln.; finds (tb,ps,tf)
% given (xe0,ye0; w,el); min tf w.r.t. tb, max tf w.r.t.ps;
%                                                        3/9/02
%
tic; w=1/3; el=1/4; xe0=1; ye0=1.5; X0=[1.9 4.4];
optn=optimset('display','iter','maxiter',50,'TolFun',1e-9);
X=fsolve('hochb_f',X0,optn,w,el,xe0,ye0);
tb=X(1); ps=X(2); cp=cos(ps); sp=sin(ps); 
[f,xf,yf,xef,yef,tf,thf]=hochb_f(X,w,el,xe0,ye0);
t1=0:tb/10:tb; th1=-t1; for i=1:11, x1(i)=-1+cos(th1(i));
   y1(i)=-sin(th1(i)); xe1(i)=xe0+w*t1(i)*sp; ye1(i)=ye0+...
   w*t1(i)*cp; end; cb=cos(tb); sb=sin(tb);
t2=[tb:(tf-tb)/100:tf]; th2=[-tb:(thf+tb)/100:thf]; for i=1:101,
   x2(i)=2*cb-1-cos(th2(i)); y2(i)=2*sb+sin(th2(i));
   xe2(i)=xe0+w*t2(i)*sp; ye2(i)=ye0+w*t2(i)*cp; end
z=0:pi/90:2*pi;
for i=1:181, xc(i)=1-cos(z(i)); yc(i)=sin(z(i)); xz(i)=xf+...
   el*cos(z(i)); yz(i)=yf+el*sin(z(i)); end
%
figure(1); clf; plot(xe0,ye0,'go',xf,yf,'bo',-1+cb,sb,'bo',...
   xc,yc,'r--',-xc,yc,'r--',xz,yz,'b',xef,yef,'go',xe1,ye1,...
   'g',xe2,ye2,'g',x1,y1,'b',x2,y2,'b',0,0,'bo',2*cb-1,2*sb,...
   'bo',[-1 2*cb-1],[0 2*sb],'b--',[2*cb-1 xf],[2*sb yf],...
   'b--',[xf xef],[yf yef],'g--'); grid; axis([-2.8 1.2 -1 3]);
axis('square'); xlabel('x, x_e'); ylabel('y, y_e');
title('Min t_f w.r.t.t_b, Max t_f w.r.t. \psi')
%
% Evader position relative to pursuer in rotating coordinates:
xr1=xe1-x1; yr1=ye1-y1; xr2=xe2-x2; yr2=ye2-y2;
xp1=xr1.*cos(th1)-yr1.*sin(th1); yp1=xr1.*sin(th1)+yr1.*cos(th1);
xp2=xr2.*cos(th2)-yr2.*sin(th2); yp2=xr2.*sin(th2)+yr2.*cos(th2);
for i=1:181, xc(i)=el*cos(z(i)); yc(i)=el*sin(z(i)); end
%
figure(2); clf; plot(xp1,yp1,xp2,yp2,'b',xc,yc,'b',xe0,ye0,'bo'); 
grid; axis([-.5 3.5 -2.5 1.5]); axis('square'); 
xlabel('x_{rel}'); ylabel('y_{rel}'); hold on
title('Evader Relative to Pursuer in Rotating Coordinates')
%
% Analytic solution in rotating coordinates (Bryson & Ho):
psf=ps-thf; psr=[psf:(1.8*pi-psf)/40:1.8*pi]; 
for i=1: length(psr); z=psr(i)-psf; x(i)=(el-w*z)*sin(psr(i))...
   +1-cos(z); y(i)=(el-w*z)*cos(psr(i))+sin(z); end
plot(x,y,'b.'); axis([-.5 3.5 -2 2]); axis('square');
hold off
toc