% f10_19 plots Figure 10.19
% Copyright S. Nakamura, 1995
figure(1)
set(gcf,'NumberTitle','off','Name','Figure10.19')
clear, clg
x = -4:0.1:2;
fex= exp(x);
gamm=1 + x.*( 1 + x/2.*(1 + x/3.*(1 + x/4)));
%gamm = 1 + x + x.^2/2 + x.^3/2/3 + x.^4/2/3/4; 
plot(x,fex,'-')
hold on
plot(x,gamm,'--')
plot([-2.785,-2.785], [0,4],':')
axis([-4,2,0,4]);
h=text(-3.5,2, 'g')  ; 
set(h, 'FontName','Symbol', 'Fontsize',[18])
b=text(0.2,1,'exp(  h)');
set(b, 'Fontsize',[18])

a=text(0.7, 0.99,'a');
set(a, 'FontName','Symbol', 'Fontsize',[18])

a=text(0.35, -0.31, 'a');
set(a, 'FontName','Symbol', 'Fontsize',[18])
b=text(0.5, -0.3, 'h');
set(b, 'Fontsize',[18])

b=text(-2.7, 1.5, 'h=-2.785');
set(b, 'Fontsize',[18],'Rotation', [90])
a=text(-2.69, 1.4, 'a');
set(a, 'FontName','Symbol', 'Fontsize',[18], 'Rotation', [90])

s=text(-3.9, 3.5,'Unstable');
set(s, 'Fontsize',[16])
u=text(-2.5,3.5, 'Stable');
set(u, 'Fontsize',[16])
