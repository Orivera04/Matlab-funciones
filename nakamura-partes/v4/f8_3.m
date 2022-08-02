% f8_3  
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 8.3')

clear, clg,hold off    
x = [0.15,  0.4,   0.6,   1.01,  1.5,   2.2,   2.4,   2.7,
     2.9,   3.5,   3.8,   4.4,   4.6,   5.1,   6.6,   7.6];
y = [4.4964,5.1284,5.6931,6.2884,7.0989,7.5507,7.5106,8.0756,
     7.8708,8.2403,8.5303,8.7394,8.9981,9.1450,9.5070,9.9115];
loglog(x,y,'x');
axis([0, 10, 0. 10])
 c = polyfit(log(x), log(y), 1);
xp = 0.1:0.1:10;
yp = exp(c(1)*log(xp) + c(2));
subplot(221)
loglog(x,y,'x')
hold on
loglog(xp,yp)
ylabel('y'); xlabel('x')
%text( 0.1, 2, 'y = 1.7646x + 0.2862')
title('(a) Loglog plot of y vs x')

%axis('square')
hold off
subplot(222)
plot(log(x), log(y), 'x')
hold on
plot(log(xp), log(yp))
%axis('square')
xlabel('log(x)'); ylabel('log(y)')
title('(b) Linear plot of log(y) vs log(x)')

hold off
subplot(223)
plot(x, y, 'x')
hold on
plot(xp, yp)
xlabel('x'); ylabel('y')
title('(c) Linear plot of y vs x')
%print Ex8dotB.ps
