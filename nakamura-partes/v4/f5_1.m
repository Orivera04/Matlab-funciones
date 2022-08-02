% f5_1 
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 5.1')

clear, clg, hold off
axis([-1 5 -0.5 5])
hold on
plot([0,4],[0,0])
plot([0,0],[0,4])
axis([-1 4 -1 4])
 x = 0:0.1:3.5;
 y = 3 - 0.4*x.*x + exp(x)/19 + 0.1*sin(x);
plot(x,y)

xp = 0.9:2:2.9;
 yp = 3 - 0.4*xp.*xp + exp(xp)/19 + 0.1* sin(xp);

for k=1:2
plot([xp(k),xp(k)], [0,yp(k)], ':')
text(xp(k)-0.1,yp(k)+0.2 , ['f',int2str(k)])
if k==1,
text(xp(k)-0.3, -0.2, ['x',int2str(k)','=a'])
end
if k==2,
text(xp(k)-0.3, -0.2, ['x',int2str(k)','=b'])
end
end


plot(xp,yp, '--')
plot(xp,yp, 'o')

text(3.8,-0.3, 'x')
text(-0.2,3.5,'y')
text(2,2,'y = f(x)')

axis([-1 5 -0.5 4.5])
axis('off')
%print  fig5D3.ps

