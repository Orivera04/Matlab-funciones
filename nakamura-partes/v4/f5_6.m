% f5_6: Fig. 5.6, 5.7, and 5.8 are plotted.
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 5.6, 5.7, and 5.8')

clear, clg
hold off
a = 0; b=1;
Zm=6;h=Zm/30;
z=-Zm:h:Zm;
x = (a+b+(b-a)*tanh(z))/2;
plot(x,z, x,z,'.')
m=length(x);
hold on
for i=1:m
plot([0,x(i)],[z(i),z(i)],'-')
plot([x(i),x(i)],[z(1),z(i)],'-')
end 
text(0.2540,   -7.3021, 'Determined points on x axis',...
'FontSize',[18])
g2=text( -0.0947,   -3.9589,  ' Equispaced points on z axis');
set(g2,'FontSize',[18],'Rotation',[90])
g1 = text(0.1824, 6.4223,'a=1, b=1, xi = 0.5*(1 + tanh(zi))');
set(g1,'FontSize',[18])
text(x(40),z(1)-2,'x')
%text(x(9),z(1),'xi')
%print expon_demo2A.ps

pause(4)

clg
hold off
%axis([0 1 0  7]); hold on
y = exp(-x.^2)./(sqrt(1-x.^2));
plot(x,y,x,y,'o')
axis([0 1 0  7])
%title('a=1, b=1, xi = 0.5*(a+b+(b-a)tanh(zi))')

yg4=text( 0.5058,   -0.5543, 'x');
set(yg4, 'FontSize',[18])

yg3=text( -0.1039,    3.7361,  'y');
set(yg3, 'FontSize',[18])

text(0.1,6.4,'o: data points on x-y coordinates','FontSize',[18])
text(0.1,5.5,  'y=exp(-x^2)/sqrt(1-x^2)','FontSize',[18])


pause(4)

clg
hold off
y = exp(-x.^2)./(sqrt(1-x.^2))./cosh(z).^2/2;
plot(z,y,z,y,'o')
%title('a=1, b=1, xi = 0.5*(5 + 5*tanh(zi))');
text(-5.8,0.64, 'g(z) = (dz/dx)exp(-x^2)/(sqrt(1-x^2)','FontSize',[18])

yg8=text( 1.122,   -0.0739,  'z');
set(yg8, 'FontSize',[18])

yg5=text( -7.6074 ,   0.3346,  'g(z)');
set(yg5, 'FontSize',[18], 'Rotation', [90])

text(0.2,5.4,'o: data points determined by','FontSize',[18])
text(0.2,5,  '   exponential transformation','FontSize',[18])

axis([-6 6 0 0.7])

%print expon_demo2C.ps
 I = sum(y)*h;

