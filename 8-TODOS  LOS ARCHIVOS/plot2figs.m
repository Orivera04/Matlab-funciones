% This creates 2 different plots, in 2 different
%  Figure Windows, to demonstrate some plot features

clf  
x = 1:5;  % Not necessary
y1 = [2 11 6 9 3];
y2 = [4 5 8 6 2];
% Put plots using different y values on one plot
% with a legend
figure(2)
plot(x,y1,'r')
hold on
plot(x,y2,'b')
grid on
legend('y1','y2')
