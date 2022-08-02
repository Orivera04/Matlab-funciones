% L8_2 same as f8_4   
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 8.4; List 8.2')

clear, clg, hold off
x = [0.1, 0.4, 0.5, 0.7, 0.7, 0.9]';  
y = [0.61, 0.92, 0.99, 1.52, 1.47, 2.03]';
cc = polyfit(x,y,2);
xx = 0:0.1:1;
yy = polyval(cc,xx);
plot(xx,yy); hold on
plot(x,y,'x')
axis([0, 1, 0, 3])
xlabel('X')
ylabel('Y')
