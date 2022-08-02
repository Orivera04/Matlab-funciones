% fig4_1
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 4.1')

clear, clg, hold off
axis([-1 5 -0.5 5])
hold on
plot([0,4],[0,0])
plot([0,0],[0,4])
axis([-1 4 0 4])
 x = 0:0.1:3.5;
 y = 3 - 0.4*x.*x + exp(x)/19 + 0.1*sin(x);
plot(x,y)

xp = 0.9:2:2.9;
 yp = 3 - 0.4*xp.*xp + exp(xp)/19 + 0.1* sin(xp);

for k=1:2
plot([xp(k),xp(k)], [0,yp(k)], ':')
if k==1,
text(xp(k)-0.25, -0.2, ['x',' = a'],'Fontsize', [18])
text(xp(k)-0.1,yp(k)+0.3 , ['f(a)'],'Fontsize', [18])

end
if k==2,
text(xp(k)-0.25, -0.2, ['x',' = b'],'Fontsize', [18])
text(xp(k)-0.1,yp(k)+0.3 , ['f(b)'],'Fontsize', [18])

end
end

xi(1) = 0.1;
yi(1) = (yp(2) - yp(1))/(xp(2) - xp(1))*(0.05 - xp(1) ) + yp(1);

xi(2) = 3.4;

yi = (yp(2) - yp(1))/(xp(2) - xp(1))*(xi - xp(1) ) + yp(1);


plot(xi,yi, '--')
plot(xp,yp, 'o')

text(3.8,-0.3, 'x','Fontsize', [18])
text(-0.2,3.5,'y','Fontsize', [18])
text(2,2,'y = f(x)','Fontsize', [18])
text(1.3,1.5,'y = g(x)','Fontsize', [18])

axis([-0.2 4 -0.1 4.1])
axis('off')
%print  fig4d1.ps

