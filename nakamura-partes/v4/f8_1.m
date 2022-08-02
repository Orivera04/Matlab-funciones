% f8_1   
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 8.1')

clear,clg
x = [0.1,  0.4,  0.5,  0.7   0.7   0.9];
y = [0.61, 0.92, 0.99, 1.52, 1.47, 2.03];
c = polyfit(x,y,1);
plot(x,y,'x')
axis([0, 1.0, 0. 2.2])
hold on

xp = 0:0.01:1;
yp = c(1)*xp + c(2);
plot(xp,yp)
ylabel('Y'); xlabel('X')
text( 0.1, 2, 'y = 1.7646x + 0.2862')
