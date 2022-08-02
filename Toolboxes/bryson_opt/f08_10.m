% Script f08_10.m; min distance to an ellipse with b=1, a=2;
%                                               7/98, 4/4/02
%
a=2; b=1; x1=[.2:.2:1.4]; N=length(x1); for i=1:N, x=x1(i); 
   th(i)=atan(a*sqrt((a-b^2/a-x)*(a-b^2/a+x))/(b*x));
   S(i)=b^2*x/((a^2-b^2)*cos(th(i)));
   xf(i)=x+S(i)*cos(th(i)); yf(i)=S(i)*sin(th(i));
end; th=[pi/2 th]; S=[1 S]; xf=[0 xf]; yf=[1 yf]; x=[0 x1];
xe=[0:.02:2]; for i=1:101, ye(i)=b*sqrt(1-xe(i)^2/a^2); end
S1=[.1:.1:.9];
for i=1:101, for j=1:9, th1=atan2(a^2*ye(i),b^2*xe(i)); 
   yt(i,j)=ye(i)-S1(j)*sin(th1); xt(i,j)=xe(i)-S1(j)*cos(th1);  
end; end
%
figure(1); clf; plot(1.5,0,'ro',xe,ye,'b',xe,-ye,'b',...
    [1.5 2],[0 0],'b'); hold on
for i=1:N+1, plot([x(i) xf(i)],[0,yf(i)],'b',[x(i) xf(i)],...
      [0 -yf(i)],'b'); end 
for j=1:5, plot(xt(:,j),yt(:,j),'r--',xt(:,j),-yt(:,j),...
      'r--'); end
plot(xt([1:93],6),yt([1:93],6),'r--',xt([1:93],6),-yt([1:93],6),'r--');
plot(xt([1:83],7),yt([1:83],7),'r--',xt([1:83],7),-yt([1:83],7),'r--');
plot(xt([1:70],8),yt([1:70],8),'r--',xt([1:70],8),-yt([1:70],8),'r--');
plot(xt([1:51],9),yt([1:51],9),'r--',xt([1:51],9),-yt([1:51],9),'r--');
hold off; grid; text(1.4,.1,'Focal Point'); axis([0 2.67*.96 -1 1])
xlabel('x'); ylabel('y')
%print -deps2 \book_do\figures\f08_10
   
