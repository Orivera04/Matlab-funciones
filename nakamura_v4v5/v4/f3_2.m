% f3_2
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 3.2')

clear,clg, hold off
axis([-3,-4+22, -5 6])
hold on
xa=-3:3;
ya=xa;

for k=0:2
m=k*7;
plot(xa+m,zeros(size(xa)))
plot(zeros(size(ya))+m, ya)
x=-3:2;
y=x+1;
plot(x+m,y)
text(m+0.2,3-0.1,'y')
text(m+3.2,-0.0,'x')

if k==0, 
text(m-1,-3.7, 'Case A'),
text(-2.0,5,'Infinite number ')
text(-1.5,4.6,'of solutions')
end

if k==1, 
text(m-1,-3.7, 'Case B'),
plot(x+m,y-1)
text(5.5,5,'No solution')
end

if k==2, 
text(m-1,-3.7, 'Case C'),
y2=-0.5*x-1;
plot(x+m,y2)
x3=-1.5:1.5;
y3=2*x3;
plot(x3+m,y3)
text(12.5,5,'No solution')
end
end
 axis('off')
