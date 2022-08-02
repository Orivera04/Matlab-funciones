% fig5_3 
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 5.3')

clear, clf, hold off
axis([-1 5 -0.5 5])
hold on
plot([0,4],[0,0])
plot([0,0],[0,4])
axis([-1 4 -1 4])
 x = 0:0.1:3.5;
 y = 3 - 0.1*x.*x + exp(-x.*x*4)/19 + 0.9*cos(1.8*x);
plot(x,y)

xp = 0.9:1:2.9;
 yp = 3 - 0.1*xp.*xp + exp(-xp.*xp*4)/19 + 0.9* cos(1.8*xp);

for k=1:3
plot([xp(k),xp(k)], [0,yp(k)], ':')
text(xp(k)-0.1,yp(k)+0.2 , ['f',int2str(k)],'FontSize',[18])
if k==1,
text(xp(k)-0.3, -0.2, ['x',int2str(k)','=a'],'FontSize',[18])
end
if k==2,
text(xp(k)-0.1, -0.2, ['x',int2str(k)',''],'FontSize',[18])
end
if k==3,
text(xp(k)-0.3, -0.2, ['x',int2str(k)','=b'],'FontSize',[18])
end
end

xc = xp(1):0.1:xp(3);

c = polyfit(xp,yp,2);
yc = polyval(c,xc);




plot(xc,yc, '--')
plot(xp,yp, 'o')

text(3.8,-0.3, 'x','FontSize',[18])
text(-0.2,3.5,'y','FontSize',[18])
text(3.4,2.9,'y = f(x)','FontSize',[18])
text(1.1,3.8,'Area under the dotted curve equals','FontSize',[18])
text(1.1,3.5,'the result of the Simpson 1/3 rule.','FontSize',[18])
axis([-0.2 4.5 -0.5 4.2])
axis('off')
%print  fig5D3.ps

