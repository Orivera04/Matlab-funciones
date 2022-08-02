function superf = cilindrofC(h,r,c)
%representa un cilindro de radio r, altura h y eje pasando por C(con circunferencias paralelas
%h=altura
%r=radio
%C=centro. C=[c(1) c(2)]
t=0:2*pi/20:2*pi;
[m,n]=size(t);

for k=0:0.1:h
    z=k*ones(1,n);
    plot3(c(1)+r*cos(t),c(2)+r*sin(t),z);
    hold on
end
