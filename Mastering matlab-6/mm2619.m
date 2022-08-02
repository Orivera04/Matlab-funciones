x = -7.5:.5:7.5; y = x;   % create a data set
[X,Y] = meshgrid(x,y);
R = sqrt(X.^2+Y.^2)+eps;
Z = sin(R)./R;
subplot(2,2,1)
surf(X,Y,Z)
view(-37.5,30)
xlabel('X-axis'), ylabel('Y-axis'), zlabel('Z-axis')
title('Figure 26.19a: Default Az = -37.5, El = 30')
subplot(2,2,2)
surf(X,Y,Z)
view(-37.5+90,30)
xlabel('X-axis'), ylabel('Y-axis'), zlabel('Z-axis')
title('Figure 26.19b: Az Rotated to 52.5')
subplot(2,2,3)
surf(X,Y,Z)
view(-37.5,60)
xlabel('X-axis'), ylabel('Y-axis'), zlabel('Z-axis')
title('Figure 26.19c: El Increased to 60')
subplot(2,2,4)
surf(X,Y,Z)
view(0,90)
xlabel('X-axis'), ylabel('Y-axis')
title('Figure 26.19d: Az = 0, El = 90')