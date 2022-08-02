% Script f10_13m.m; min distance path of tractor-trailer to go from 
% loading dock to specified position and orientation; finds (ps,al)
% histories using inverse control and NLP code CONSTR; control (front
% wheel steering angle) is bang-singular-bang-bang going forward;
%                                                       2/98, 4/4/02
%
clear; load ttp; p=p0;                      % Converged solution for N=81 
N=length(p0); un=ones(1,N-1); N1=N+1; psf=-3*pi/4; alf=0; yf=-.3; xf=1.3;
uo=5/3; sf=[psf alf yf xf]'; 
[c,ceq,x,y,ps,u]=tt_c(p,N,sf,uo); al=[0 p(1:N-1) alf]; be=ps-al; a=.5;
b=.2; yf=y+(b+a)*sin(ps); xf=x+(b+a)*cos(ps); yb=y-sin(be); xb=x-cos(be);
de=(u/uo)*(40*pi/180); de=[de de(N1-1)]; al=ps+de; ga=ps+de; w=.06; z=.1;
for i=1:N1, xp(:,i)=[xb(i) x(i) xf(i)]'; yp(:,i)=[yb(i) y(i) yf(i)]'; end 
%
figure(1); for k=1:2; clf; for i=N1:-1:1,  
   s1=sin(ps(i)); c1=cos(ps(i)); s2=sin(be(i)); c2=cos(be(i));
   s3=sin(ga(i)); c3=cos(ga(i));
   x1=x(i)+b*c1+(b/2)*s1; x2=x1+a*c1; x3=x2-b*s1; x4=x3-a*c1;
   y1=y(i)+b*s1-(b/2)*c1; y2=y1+a*s1; y3=y2+b*c1; y4=y3-a*s1;
   x5=x(i)+(b/2)*s2; x6=x5-b*s2; x7=x6-c2; x8=x7+b*s2;
   y5=y(i)-(b/2)*c2; y6=y5+b*c2; y7=y6-s2; y8=y7-b*c2;
   plot([x1 x2 x3 x4 x1],[y1 y2 y3 y4 y1],'b',[x5 x6 x7 x8 x5],...
      [y5 y6 y7 y8 y5],'b',[-1 -1],[-.5 .5],'r--',xp(:,1),...
      yp(:,1),'r--',xp(:,N1),yp(:,N1),'r--',[x(i) x(i)+b*c1],...
      [y(i) y(i)+b*s1],'b',x(i),y(i),'bo',[x2-w*c1 x3-w*c1],...
      [y2-w*s1 y3-w*s1],'b',[x2 x2+z*c3],[y2 y2+z*s3],'b',...
      [x3 x3+z*c3],[y3 y3+z*s3],'b'); 
   axis([-1 3.5 -1.55 1.85]); axis off; pause(.15)
end; pause(2); end; pause(2)
%
figure(2); clf; for i=N1:-3:1  
   s1=sin(ps(i)); c1=cos(ps(i)); s2=sin(be(i)); c2=cos(be(i));
   s3=sin(ga(i)); c3=cos(ga(i));
   x1=x(i)+b*c1+(b/2)*s1; x2=x1+a*c1; x3=x2-b*s1; x4=x3-a*c1;
   y1=y(i)+b*s1-(b/2)*c1; y2=y1+a*s1; y3=y2+b*c1; y4=y3-a*s1;
   x5=x(i)+(b/2)*s2; x6=x5-b*s2; x7=x6-c2; x8=x7+b*s2;
   y5=y(i)-(b/2)*c2; y6=y5+b*c2; y7=y6-s2; y8=y7-b*c2;
   plot([x1 x2 x3 x4 x1],[y1 y2 y3 y4 y1],'b',[x5 x6 x7 x8 x5],...
      [y5 y6 y7 y8 y5],'b',[-1 -1],[-.5 .5],'r--',xp(:,1),...
      yp(:,1),'r--',xp(:,N1),yp(:,N1),'r--',[x(i) x(i)+b*c1],...
      [y(i) y(i)+b*s1],'b',x(i),y(i),'bo',[x2-w*c1 x3-w*c1],...
      [y2-w*s1 y3-w*s1],'b',[x2 x2+z*c3],[y2 y2+z*s3],'b',...
      [x3 x3+z*c3],[y3 y3+z*s3],'b');  
   axis([-1 3.5 -1.55 1.85]); axis off; pause(.5); hold on 
  end; hold off
 

