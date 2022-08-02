

function [] = SVDdemo(A)

% This illustrates a geometric effect of the application 
% of the 2-by-2 matrix A to the unit circle C.

t = linspace(0,2*pi,200);
x = sin(t);
y = cos(t);
[U,S,V] = svd(A);
vx = [0 V(1,1) 0 V(1,2)];
vy = [0 V(2,1) 0 V(2,2)];
axis square
hold on
h1_line = plot(x,y,vx,vy);
set(h1_line(1),'LineWidth',1.25)
set(h1_line(2),'LineWidth',1.25,'Color',[0 0 0])
grid on
title('Figure 1. Unit circle C and right singular vectors v_i')
pause(5)
hold off
w = [x;y];
z = A*w;
U = U*S;
udx = [0 U(1,1) 0 U(1,2)];
udy = [0 U(2,1) 0 U(2,2)];
figure
hold on
h1_line = plot(udx,udy,z(1,:),z(2,:));
set(h1_line(2),'LineWidth',1.25,'Color',[0 0 1])
set(h1_line(1),'LineWidth',1.25,'Color',[0 0 0])
grid on
title('Figure 2. Image A*C of C and vectors \sigma_iu_i')
hold off






