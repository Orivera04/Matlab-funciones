% f5_4 
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 5.4')

clear, clf, hold off
 c = Legen_pw(7);
x=-1:0.01:1;
r=roots(c);
y =  polyval(c,x);
hold on 
plot(x,y)
plot(r,zeros(size(r)),'o')
axis([-1,1,-1,1]);
set(gca, 'FontSize',[18])
%[x1,y1]=ginput(1);
x1=0.06; y1=-1.18;
text(x1,y1,'x','FontSize',[18])
%[x1,y1]=ginput(1);
x1=-1.2171; y1=0.132; 
text(x1,y1,'y','FontSize',[18])
text(-0.8, -0.8,'Legendre polynomial of order 7','FontSize',[18])
text(-0.8, -0.9,'and Legendre points: o marks','FontSize',[18])

