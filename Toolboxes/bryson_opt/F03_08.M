% Script f03_08.m; TDP for max uf with vf=0 and specified 
% (tf,xf,yf); finds p=(thb0,thbf) in analytic solution to
% satisfy terminal BCs using FSOLVE; (u,v) in a*tf, (x,y)
% in a*tf^2, t in tf;                        2/97, 4/2/02
%
c=pi/180; p0=c*[75 -80]; optn=optimset('Display','Iter');
xf=.2; yf=.2; p=fsolve('tdpx_f',p0,optn,xf,yf);
[f,m,al]=tdpx_f(p,xf,yf);
%
b0=p(1); t=[0:.01:1]; N=101; un=ones(1,N); 
b=atan(un*tan(b0)-m*t); fu=asinh(tan(b0))-asinh(tan(b)); 
fv=sec(b0)-sec(b); fx=fv-tan(b).*fu; fy=(m*sec(b0).*t...
  -tan(b).*fv-fu)/2; u=(fu*cos(al)-fv*sin(al))/m;
v=(fu*sin(al)+fv*cos(al))/m; x=(fx*cos(al)-fy*...
  sin(al))/m^2; y=(fx*sin(al)+fy*cos(al))/m^2; 
th=b+al*un;
%
figure(1); clf; subplot(211), plot(t,th/c); grid 
ylabel('\theta (deg)'); subplot(212), plot(t,u,t,v,'r--');
grid; xlabel('t/t_f'); legend('u/at_f','v/at_f',2);
%print -deps2 \book_do\figures\f03_08
%
figure(2); clf; plot(x,y,x(N),y(N),'ro',0,0,'ro'); grid 
axis([-.02 .20 0 .22]); axis('square'); xlabel('x/at_f^2');
ylabel('y/at_f^2');
%print -deps2 \book_do\figures\f03_09

	