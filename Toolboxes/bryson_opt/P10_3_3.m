% Script p10_3_3.m; min distance path of tractor-trailer; finds (psi,
% alpha) histories for min tf from s0 to sf using inverse control (alpha
% as key state history) & NLP code FMINCON; path is `bang-singular-bang-
% bang' with chattering junctions;                         1/97, 3/29/02
%
p0=[.4496 .4748 .4466 .3841 .3061 .2317 .1798 .1608 .1436 .0883 .0100 ...
   -.0327 -.0223 -.0265 -.1039 -.2036 -.2403 -.2199 -.2323 -.3324 ...
   -.4827 -.6369 -.7800 -.9101 -1.0277 -1.1357 -1.2375 -1.3363...
   -1.4349 -1.5292 -1.6124 -1.6948 -1.8088 -1.9576 -2.0431 -1.9571 ...
   -1.7041 -1.3547 -0.9800 -0.6511 5.9]; N=41; % Converged soln. for N=41
load ttp; N=81;                                % Converged soln. for N=81 
un=ones(1,N-1); N1=N+1; uo=5/3; sf=[-3*pi/4 0 -.3 1.3]';
optn=optimset('Display','Iter','MaxIter',5); lb=[-pi*un  0]; ub=[pi*un 10]; 
p=fmincon('tt_f',p0,[],[],[],[],lb,ub,'tt_c',optn,N,sf,uo); tf=p(N);
dt=tf/N; tb=[dt/2:dt:tf-dt/2]; 
[c,ceq,x,y,ps,u]=tt_c(p,N,sf,uo); al=[0 p(1:N-1) 0]; yf=y+.5*sin(ps);
xf=x+.5*cos(ps); be=ps-al; yb=y-sin(be); xb=x-cos(be);
for i=1:N+1, xp(:,i)=[xb(i) x(i) xf(i)]'; yp(:,i)=[yb(i) y(i) yf(i)]';
end; de=(u/uo)*(40*pi/180); de=[de de(N)]; ga=ps+de; b=.2; a=.5; w=.1;
z=.1;
%
figure(1); clf; plot(tb,u/uo); grid; axis([0 6 -1.1 1.1]); 
xlabel('Distance Along Path'); ylabel('u/uo'); pause(5);
%
figure(2); for k=1:2; clf; for i=N1:-1:1,  
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
      [x3 x3+z*c3],[y3 y3+z*s3],'b'); axis([-1 3.5 -1.55 1.85]);
      axis off; if i==N1, pause(3); else pause(.1); end
end; pause(1); end; pause(1)
%
figure(3); clf; for i=N1:-5:1  
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
   axis([-1 3.5 -1.55 1.85]); axis off; hold on 
  end; hold off
 


