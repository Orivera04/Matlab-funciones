% Script p2_3_4.m; max xf paths with tf specified; V=1+y (Fermat Pbs);
%                                                       10/96, 6/27/02
%
tf1=[.5 1 1.5 2]; optn=optimset('Display','Iter','MaxIter',100);
p0=40*pi/180; 
for i=1:4; tf=tf1(i); th0(i)=fsolve('ferm0',p0,optn,tf); end
un=ones(1,51); th=zeros(4,51); x=zeros(4,51); y=x;
for j=1:4, th(j,:)=th0(j)*[0:.02:1]; cj=cos(th0(j)); sj=sin(th0(j));
 x(j,:)=(un*sj-sin(th(j,:)))/cj; y(j,:)=(-un*cj+cos(th(j,:)))/cj;
end 
%
figure(1); clf; for j=1:4, plot(x(j,:),y(j,:)); hold on
plot(x(j,1),y(j,1),'o'); end; grid; hold off; axis([0 4 0 3])
text(3.4,2.55,'tf=2.0'); xlabel('x/h'); ylabel('y/h')
text(2.2,1.35,'tf=1.5'); text(1.25,.51,'tf=1.0')
text(.6,.15,'tf=0.5')