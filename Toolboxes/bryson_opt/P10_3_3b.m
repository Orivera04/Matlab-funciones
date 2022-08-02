% Script p10_3_3b.m; min distance tractor-trailer problem; bang-zero-
% bang-bang approx. (forward); s=[ps al y x]'; sfd=desired final s; u=
% (l/b)*tan(delta) where delta=steering angle; d1(i)=dist. traveled on
% ith segment, i=1:4; d0=initial guess of d1; uses subroutines TTO to
% find d1(i); makes a strobe movie of the back-up maneuver (reverse of
% forward maneuver);                                     1/97, 3/30/02
%
u0=5/3; s0=zeros(4,1); u=u0*[1 0 -1 1]'; 
optn=optimset('Display','Iter','MaxIter',1000);  
sfd=[-3*pi/4 0 -.3 1.3]'; d0=[.1 2 2 1]'; ax=[-1 4 .625*[-2.2 2.8]];  
d1=fsolve('tto',d0,optn,u,s0,sfd);
%
% Divide path into Ns segments and find state histories s(:,i), i=1:Ns:
Ns=100; D=sum(d1); for i=1:4, n(i)=round(Ns*d1(i)/D); end
un1=ones(1,n(1)); un2=ones(1,n(2)); un3=ones(1,n(3)); un4=ones(1,n(4));
u=u0*[un1 0*un2 -un3 un4]; if flg==3, u=-u; elseif flg==4, u=-u; end
d=[d1(1)*un1/n(1) d1(2)*un2/n(2) d1(3)*un3/n(3) d1(4)*un4/n(4)]; 
N=length(d); N1=N+1; [f,s,u]=tto(d,u,s0,sfd); ps=s(1,:); al=s(2,:); 
y=s(3,:); x=s(4,:); yf=y+.5*sin(ps); xf=x+.5*cos(ps); be=ps-al;
yb=y-sin(be); xb=x-cos(be); b=.2; a=.5;
for i=1:N1, xp(:,i)=[xb(i) x(i) xf(i)]'; yp(:,i)=[yb(i) y(i) yf(i)]';
end; de=(u/u0)*(40*pi/180); de=[de de(N)]; ga=ps+de; w=.06; z=.1; 
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
      [x3 x3+z*c3],[y3 y3+z*s3],'b'); axis(ax); axis off; 
      if i==N1, pause(3); else pause(.1); end
end; pause(1); end; pause(1)
%
figure(2); clf; for i=N1:-5:1  
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
      [x3 x3+z*c3],[y3 y3+z*s3],'b'); axis(ax); axis off; hold on 
  end; hold off
 
