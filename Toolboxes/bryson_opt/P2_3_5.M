% Script p2_3_5.m; VDP for max range with gravity and thrust; plots from
% analytical soln.; V in units of g*tf, a in g, (x,y) in g*tf^2, t in tf;
%                                                          10/96, 6/27/02
%
N=100; ga=(pi/2)*[1:-1/N:0]; un=ones(1,N+1); x=zeros(5,N+1); y=x; t=x;
a1=[0 .5 1 1.5 2]; M=length(a1); cg=cos(ga); sg=sin(ga);
for j=1:M, a=a1(j);
if a<1,
   b=sqrt(1-a^2); alo=(1/b)*atan((1+a)/b);
   Vf=1/((2/b^2)*(alo-(1/b)*atan(a/b))-a/b^2); 
   al=(1/b)*atan((a*un+tan(ga/2))/b);
   x(j,:)=Vf^2*((1/b^2)*(alo*un-al)-(1/(2*b^2))*cg.*...
      (a*un+sg)./(un+a*sg).^2);
   y(j,:)=Vf^2*((1/(2*(1+a)^2))*((cg).^2+2*a*sg.*...
      (un-sg))./(un+a*sg).^2);
   t(j,:)=Vf*((2/b^2)*(alo*un-al)-(a/b^2)*cg./(un+a*sg));
elseif a>1,
   b=sqrt(a^2-1); alo=(-1/b)*atanh((1+a)/b);  
   Vf=1/((2/b^2)*(alo+(1/b)*atanh(a/b))-a/b^2); 
   al=(-1/b)*atanh((a*un+tan(ga/2))/b);
   x(j,:)=-Vf^2*((1/b^2)*(alo*un-al)-(1/(2*b^2))*cg.*...
     (a*un+sg)./(un+a*sg).^2);
   y(j,:)=Vf^2*((1/(2*(1+a)^2))*((cg).^2+2*a*sg.*...
     (un-sg))./(un+a*sg).^2);
   t(j,:)=Vf*((2/b^2)*(alo*un-al)-(a/b^2)*cg./(un+a*sg));
elseif a==1,
   x(j,:)=.75*(tan((pi/4)*un-ga/2)).^3;
   y(j,:)=(9/32)*(un-sg).*(un+3*sg)./(un+sg).^2;
   t(j,:)=.75*tan((pi/4)*un-ga/2)+.25*(tan((pi/4)*un-ga/2)).^3;
end; end
%
figure(1); clf; subplot(211), plot(x(1,:),-y(1,:),x(1,N+1),...
    -y(1,N+1),'ro',0,0,'ro'); grid; hold on
for j=2:M, plot(x(j,:),-y(j,:),x(j,N+1),-y(j,N+1),'ro'); end
hold off; axis([0 1.4 -.4 0]); xlabel('x'); ylabel('-y')
text(.27,-.18,'a = 0'); text(.5,-.23,'.5'); text(.73,-.26,'1.0')
text(.93,-.28,'1.5'); text(1.16,-.31,'2.0')
%
figure(2); clf; plot(t(1,:),x(1,:),t(1,:),-y(1,:)); hold on
for j=2:M, plot(t(j,:),x(j,:),t(j,:),-y(j,:)); end; hold off
grid; xlabel('Time'); ylabel('x & -y'); axis([0 1 -.4 1.4])

	
	