% Script hochs.m; finds (ts,tf) for bang-singular path
% given (xe0,ye0;w,el);                           3/2/02
%
clear; tic; w=1/3; el=1/4; xe0=2; ye0=1.5;
z=roots([(xe0-1)^2+ye0^2 2*(xe0-1) 1-ye0^2]);
if abs(z(1))<1, cs=z(1); else cs=z(2); end; ts=acos(cs);
ss=sin(ts); tf=(el*cs-ye0+ss-ts*cs)/(w*cs-cs);
xf=1-cs+(tf-ts)*ss; yf=ss+(tf-ts)*cs;
xef=xf+el*ss; yef=yf+el*cs;
th=[0:ts/10:ts]; for i=1:11, x(i)=1-cos(th(i));
  y(i)=sin(th(i)); end
z=0:pi/90:2*pi; for i=1:181, cz=cos(z(i)); sz=sin(z(i));
  xc(i)=1-cz; yc(i)=sz; xa(i)=xf+el*cz; ya(i)=yf+el*sz; 
end
%
figure(1); clf; plot(x,y,[1-cs xf],[ss yf],'b',...
    xe0,ye0,'go',xf,yf,'bo',1-cs,ss,'bo',xc,yc,...
    'r--',xa,ya,'b',xef,yef,'go',[xe0 xef],...
    [ye0+.01 yef+.01],'g',0,0,'bo'); grid
axis([0 3.5 -1 2.5]); axis('square'); 
xlabel('x, x_e'); ylabel('y, y_e');
text(xe0-.3,ye0+.2,'(x_{e0}, y_{e0})')
toc