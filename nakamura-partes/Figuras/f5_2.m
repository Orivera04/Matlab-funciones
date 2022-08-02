% f5_2 
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 5.2')

clear, clf, hold off
axis([-1 5 -0.5 5])
hold on
plot([0,4],[0,0])
plot([0,0],[0,4])
axis([-1 4 -1 4])
 x = 0:0.1:4;
 y = 3 - 0.4*x.*x + exp(x)/9 + sin(x);
plot(x,y)

xp = 0.5:1:3.5;
 yp = 3 - 0.4*xp.*xp + exp(xp)/9 + sin(xp);

for k=1:4
plot([xp(k),xp(k)], [0,yp(k)], ':')
text(xp(k)-0.1, -0.2, ['x',int2str(k)])
text(xp(k)-0.0, yp(k)+0.2, ['f',int2str(k)])
end



plot(xp,yp, '--')
plot(xp,yp, 'o')

text(3.8,-0.3, 'x')
text(-0.2,3.5,'y')
text(4,2,'y = f(x)')

axis([-1 5 -0.5 4.5])
axis('off')
%print  fig5D2.ps

