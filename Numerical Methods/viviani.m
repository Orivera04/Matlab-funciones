%representa la bóveda de Viviani. Pide radio r
clear all;
t=0:2*pi/30:2*pi;
n=length(t)
r=input('radio')
R=r;
[x,y]=meshgrid(-R:.1:R,-R:.1:R);
z=sqrt(4*r^2-x.^2-y.^2);
surf(x,y,z,'FaceAlpha','flat','AlphaDataMapping','scaled',...
    'AlphaData',gradient(z),'FaceColor','red')
hold on
h=zeros(1,n);
for k=1:n
    h(k)=sqrt(4*r^2-r^2*cos(t(k)).^2-r^2*(1+sin(t(k))).^2);
    s=3*r:-.1:h(k);
    m=length(s)
    x=r*cos(t(k))*ones(1,m);
    y=r*(1+sin(t(k)))*ones(1,m);
    z=s;
    plot3(x,y,z,'g')
    p=0:.1:h(k);
    q=length(p)
    x1=r*cos(t(k))*ones(1,q);
    y1=r*(1+sin(t(k)))*ones(1,q);
    z1=p;
    plot3(x1,y1,z1,'b')
    hold on
end
w=3*r*ones(1,n);
plot3(r*cos(t),r*(1+sin(t)),w,'k')
plot3(r*cos(t),r*(1+sin(t)),h,'k')
w0=zeros(1,n);
plot3(r*cos(t),r*(1+sin(t)),w0,'k')
