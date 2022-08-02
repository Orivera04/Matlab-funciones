% fig4_2
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 4.2')

clear, clg, hold off
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
text(xp(k)-0.1, -0.2, ['x',int2str(k)],'FontName','Corrier','Fontsize', [24])
text(xp(k)-0.1, yp(k)+0.4, ['y',int2str(k)],'FontName','Corrier','Fontsize', [24])
end
c = polyfit(xp,yp, length(xp)-1);
xi=0.5:0.1:3.5;
yi = polyval(c,xi);
plot(xi,yi, '--');


%plot(xp,yp, '--')
plot(xp,yp, 'o')

text(4.1,0.1, 'x','FontName','Corrier','Fontsize', [18])
text(-0.2,3.5,'y','FontName','Corrier','Fontsize', [18])
text(4,2,'y = y(x)','FontName','Corrier','Fontsize', [18])
%text(4,1.2,'y = p(x)')
axis([-0.1 4.8 -0.2 4.5])
 axis('off')


plot([2.2,2.7],[3.8,3.8])
text(2.7,3.8,' Function y(x)','FontName',...
                       'Corrier','Fontsize', [18])
plot([2.2,2.7],[3.5,3.5],'--')
text(2.7,3.5,' Cubic interpolation','FontName',...
                       'Corrier','Fontsize', [18])
%print  fig4d2.ps

